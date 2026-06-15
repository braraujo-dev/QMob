-- ======================================================
-- SCHEMA COMPLETO PARA O SUPABASE - QMob
-- ======================================================

-- 1. EXTENSÕES NECESSÁRIAS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 2. TABELAS
CREATE TABLE admins (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  phone TEXT,
  nome_sindicato TEXT NOT NULL,
  cnpj TEXT NOT NULL,
  responsavel TEXT NOT NULL,
  contato TEXT NOT NULL,
  must_change_password BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE drivers (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  admin_id UUID REFERENCES admins(id) ON DELETE SET NULL,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT NOT NULL,
  base_city TEXT NOT NULL,
  vehicle_model TEXT NOT NULL,
  vehicle_color TEXT NOT NULL,
  vehicle_plate TEXT NOT NULL,
  photo_url TEXT,
  must_change_password BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE capitals (
  id SERIAL PRIMARY KEY,
  city_name TEXT UNIQUE NOT NULL,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  radius_meters INTEGER DEFAULT 7000
);

CREATE TABLE queue (
  id SERIAL PRIMARY KEY,
  driver_id UUID REFERENCES drivers(id) ON DELETE CASCADE,
  admin_id UUID REFERENCES admins(id) ON DELETE CASCADE,
  city_name TEXT NOT NULL,
  checkin_time TIMESTAMPTZ NOT NULL
);

CREATE TABLE historic (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES drivers(id) ON DELETE CASCADE,
  admin_id UUID REFERENCES admins(id) ON DELETE CASCADE,
  origin TEXT NOT NULL,
  destination TEXT NOT NULL,
  status TEXT NOT NULL,
  date TIMESTAMPTZ NOT NULL,
  price NUMERIC(10,2)
);

CREATE TABLE union_requests (
  id SERIAL PRIMARY KEY,
  union_name TEXT NOT NULL,
  cnpj TEXT NOT NULL,
  responsible_name TEXT NOT NULL,
  phone TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. ÍNDICES
CREATE INDEX idx_drivers_admin_id ON drivers(admin_id);
CREATE INDEX idx_queue_admin_id ON queue(admin_id);
CREATE INDEX idx_queue_checkin_time ON queue(checkin_time);
CREATE INDEX idx_historic_user_id ON historic(user_id);
CREATE INDEX idx_historic_admin_id ON historic(admin_id);
CREATE INDEX idx_historic_date ON historic(date);

-- 4. RLS (POLÍTICAS DE SEGURANÇA)
ALTER TABLE admins ENABLE ROW LEVEL SECURITY;
ALTER TABLE drivers ENABLE ROW LEVEL SECURITY;
ALTER TABLE capitals ENABLE ROW LEVEL SECURITY;
ALTER TABLE queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE historic ENABLE ROW LEVEL SECURITY;
ALTER TABLE union_requests ENABLE ROW LEVEL SECURITY;

-- admins
CREATE POLICY "Admins can view own record" ON admins FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Admins can update own record" ON admins FOR UPDATE USING (auth.uid() = id);

-- drivers
CREATE POLICY "Drivers can view own record" ON drivers FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Drivers can update own record" ON drivers FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Admins can view all their drivers" ON drivers FOR SELECT USING (auth.uid() IN (SELECT admin_id FROM drivers WHERE id = auth.uid()) OR EXISTS (SELECT 1 FROM admins WHERE id = auth.uid()));
CREATE POLICY "Admins manage their drivers" ON drivers FOR ALL USING (EXISTS (SELECT 1 FROM admins WHERE id = auth.uid()) AND admin_id = auth.uid());

-- capitals
CREATE POLICY "Anyone can view capitals" ON capitals FOR SELECT USING (true);

-- queue
CREATE POLICY "Authenticated users can view queue" ON queue FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Drivers can insert their own queue entry" ON queue FOR INSERT WITH CHECK (auth.uid() = driver_id AND EXISTS (SELECT 1 FROM drivers WHERE id = driver_id));
CREATE POLICY "Drivers can delete own queue entry" ON queue FOR DELETE USING (auth.uid() = driver_id);
CREATE POLICY "Admins manage queue" ON queue FOR ALL USING (EXISTS (SELECT 1 FROM admins WHERE id = auth.uid()) AND admin_id = auth.uid());

-- historic
CREATE POLICY "Authenticated users view historic" ON historic FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "System can insert historic" ON historic FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- union_requests
CREATE POLICY "Anyone can insert union_requests" ON union_requests FOR INSERT WITH CHECK (true);
CREATE POLICY "No select for union_requests" ON union_requests FOR SELECT USING (false);

-- 5. DADOS INICIAIS: CAPITAIS
INSERT INTO capitals (city_name, latitude, longitude, radius_meters) VALUES
('Salvador', -12.9714, -38.5014, 7000),
('Fortaleza', -3.7172, -38.5433, 7000),
('Recife', -8.0476, -34.8770, 7000),
('São Luís', -2.5307, -44.3068, 7000),
('Maceió', -9.6659, -35.7350, 7000),
('Natal', -5.7793, -35.2009, 7000),
('Teresina', -5.0892, -42.8016, 7000),
('João Pessoa', -7.1150, -34.8610, 7000),
('Aracaju', -10.9472, -37.0731, 7000),

-- 6. CRIAÇÃO AUTOMÁTICA DO ADMIN
DO $$
DECLARE
  user_email TEXT := 'admin@qmob.com';
  user_password TEXT := 'admin123';
  new_user_id UUID;
BEGIN
  INSERT INTO auth.users (
    instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
    raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
    confirmation_token, email_change, email_change_token_new, recovery_token, is_sso_user
  )
  VALUES (
    '00000000-0000-0000-0000-000000000000',
    gen_random_uuid(),
    'authenticated',
    'authenticated',
    user_email,
    crypt(user_password, gen_salt('bf')),
    now(),
    jsonb_build_object('provider', 'email', 'providers', ARRAY['email']),
    '{}'::jsonb,
    now(),
    now(),
    '',
    '',
    '',
    '',
    false
  )
  RETURNING id INTO new_user_id;

-- 7. DADO DE USER ADMIN
  INSERT INTO admins (id, full_name, phone, nome_sindicato, cnpj, responsavel, contato, must_change_password)
  VALUES (
    new_user_id,
    'Admin Teste',
    '11999999999',
    'Sindicato Exemplo',
    '00.000.000/0001-00',
    'João Silva',
    'joao@exemplo.com',
    true
  );
END $$;