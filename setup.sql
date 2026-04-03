-- ══════════════════════════════════════════════
--  OTOTECH ONLINE QUESTIONS MANAGEMENT SYSTEM — SUPABASE SETUP SQL
--  Run this in: Supabase → SQL Editor → New Query
-- ══════════════════════════════════════════════

-- 1. QUESTIONS TABLE
CREATE TABLE IF NOT EXISTS questions (
  id              SERIAL PRIMARY KEY,
  question        TEXT NOT NULL,
  category        TEXT NOT NULL CHECK (category IN ('civil', 'affairs', 'edu', 'ict', 'religion', 'entrance')),
  option_a        TEXT NOT NULL,
  option_b        TEXT NOT NULL,
  option_c        TEXT NOT NULL,
  option_d        TEXT NOT NULL,
  correct_answer  INTEGER NOT NULL CHECK (correct_answer IN (0, 1, 2, 3)),
  active          BOOLEAN DEFAULT TRUE,
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- 2. EXAM RESULTS TABLE
CREATE TABLE IF NOT EXISTS exam_results (
  id              SERIAL PRIMARY KEY,
  name            TEXT NOT NULL,
  email           TEXT,
  phone           TEXT,
  organisation    TEXT,
  selected_category TEXT,
  score           INTEGER NOT NULL,
  total           INTEGER NOT NULL,
  percentage      INTEGER NOT NULL,
  grade           TEXT NOT NULL,
  correct_count   INTEGER DEFAULT 0,
  wrong_count     INTEGER DEFAULT 0,
  skipped_count   INTEGER DEFAULT 0,
  civil_score     INTEGER DEFAULT 0,
  affairs_score   INTEGER DEFAULT 0,
  edu_score       INTEGER DEFAULT 0,
  ict_score       INTEGER DEFAULT 0,
  religion_score  INTEGER DEFAULT 0,
  entrance_score  INTEGER DEFAULT 0,
  answers_detail  JSONB,
  time_taken_secs INTEGER,
  taken_at        TIMESTAMPTZ DEFAULT NOW()
);

-- 3. ACCESS CODES TABLE
CREATE TABLE IF NOT EXISTS access_codes (
  id          SERIAL PRIMARY KEY,
  code        TEXT NOT NULL UNIQUE,
  label       TEXT,
  active      BOOLEAN DEFAULT TRUE,
  use_count   INTEGER DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- 4. ENABLE REALTIME on exam_results
ALTER TABLE exam_results REPLICA IDENTITY FULL;

-- 5. ROW LEVEL SECURITY (open for now — tighten after setup)
ALTER TABLE questions     ENABLE ROW LEVEL SECURITY;
ALTER TABLE exam_results  ENABLE ROW LEVEL SECURITY;
ALTER TABLE access_codes  ENABLE ROW LEVEL SECURITY;

-- Allow public read of questions and access_codes
CREATE POLICY "Public read questions"    ON questions     FOR SELECT USING (true);
CREATE POLICY "Public read codes"        ON access_codes  FOR SELECT USING (true);
-- Allow anyone to insert exam results
CREATE POLICY "Public insert results"    ON exam_results  FOR INSERT WITH CHECK (true);
-- Allow admin (anon key) to read all results
CREATE POLICY "Public read results"      ON exam_results  FOR SELECT USING (true);
-- Allow admin to manage questions and codes
CREATE POLICY "Admin manage questions"   ON questions     FOR ALL USING (true);
CREATE POLICY "Admin manage codes"       ON access_codes  FOR ALL USING (true);

-- 6. SEED DEFAULT ACCESS CODES
INSERT INTO access_codes (code, label, active) VALUES
  ('OTOTECH2025', 'Default Admin Code', true),
  ('CIVIL2025',   'Civil Service Batch', true),
  ('EXAM001',     'General Access', true)
ON CONFLICT (code) DO NOTHING;

-- 7. SEED SAMPLE QUESTIONS (Civil Service)
INSERT INTO questions (question, category, option_a, option_b, option_c, option_d, correct_answer) VALUES
('Under the Nigerian Civil Service Rules, what is the minimum notice period for resignation of a confirmed officer?', 'civil', 'One month', 'Three months', 'Two months', 'Six months', 0),
('Which body is primarily responsible for the appointment, promotion, and discipline of Federal civil servants in Nigeria?', 'civil', 'Federal Executive Council', 'Federal Civil Service Commission', 'Office of the Head of Service', 'National Council of State', 1),
('According to Civil Service Rules, an officer on suspension shall receive what fraction of his salary?', 'civil', 'Full salary', 'Three-quarters salary', 'Half salary', 'No salary', 2),
('What is the maximum number of days allowed for casual leave per year under Nigerian Civil Service Rules?', 'civil', '7 days', '10 days', '14 days', '21 days', 0),
('In the Nigerian civil service, the Scheme of Service is primarily designed to:', 'civil', 'Determine salaries of officers', 'Define entry qualifications and career progression', 'Outline disciplinary procedures', 'Set annual targets for MDAs', 1),
('A civil servant found guilty of gross misconduct can be subjected to:', 'civil', 'Only demotion', 'Only fine', 'Dismissal without benefits', 'Transfer to another ministry', 2),
('What document governs the financial dealings of Nigerian federal civil servants?', 'civil', 'Finance Act', 'Financial Regulations', 'Annual Appropriation Act', 'Public Procurement Act', 1),
('Under the Civil Service Rules, a civil servant''s annual leave entitlement after 10 years of service is:', 'civil', '21 days', '30 days', '28 days', '35 days', 1),
('Which of the following is punishable as serious misconduct?', 'civil', 'Arriving 10 minutes late once', 'Engaging in partisan political activities', 'Wearing informal clothing', 'Missing a single meeting', 1),
('The probationary period for a newly appointed officer in the Nigerian civil service is:', 'civil', '6 months', '1 year', '2 years', '3 years', 2),
('Sick leave with full pay for a confirmed officer can be granted for a maximum of:', 'civil', '3 months', '6 months', '1 year', '2 years', 1),
('IPPIS in Nigeria was introduced primarily to:', 'civil', 'Monitor civil servant performance', 'Eliminate ghost workers from the payroll', 'Automate promotion exercises', 'Manage pension fund investments', 1),
('Maternity leave for female civil servants in Nigeria is:', 'civil', '6 weeks', '8 weeks', '12 weeks', '3 months', 2),
('Under the Pension Reform Act, the mandatory contribution rate for civil servants is:', 'civil', 'Employee 7.5%, Employer 7.5%', 'Employee 5%, Employer 10%', 'Employee 10%, Employer 5%', 'Employee 8%, Employer 12%', 0),
('In the Nigerian civil service, Grade Level 16 and above are classified as:', 'civil', 'Junior staff', 'Middle management', 'Senior management', 'Directors and above', 2),
('The Head of the Civil Service of the Federation holds which rank?', 'civil', 'Grade Level 16', 'Equivalent of Permanent Secretary', 'Minister', 'Above Permanent Secretary', 3),
('Under which Chapter of Civil Service Rules are conduct and discipline provisions covered?', 'civil', 'Chapter 1', 'Chapter 4', 'Chapter 10', 'Chapter 16', 1),
('An officer wishing to undertake outside employment must obtain approval from:', 'civil', 'The Ministry of Finance', 'His immediate supervisor', 'The appropriate Commission', 'The Inspector General', 2),
('A "Schedule Officer" in the Nigerian civil service is:', 'civil', 'An officer who manages schedules', 'An accounting officer responsible for expenditure control', 'An officer due for promotion', 'An officer listed for transfer', 1),
('The "Estacade" in the Nigerian civil service context refers to:', 'civil', 'A type of office accommodation', 'A daily subsistence allowance for officers on tour', 'A financial regulatory body', 'A grade level classification', 1),
-- Current Affairs
('Who is the current President of Nigeria as of 2024–2025?', 'affairs', 'Muhammadu Buhari', 'Peter Obi', 'Bola Ahmed Tinubu', 'Atiku Abubakar', 2),
('In 2023, Nigeria removed the subsidy on which commodity?', 'affairs', 'Electricity', 'Petrol (fuel subsidy)', 'Cooking gas', 'Kerosene', 1),
('The EFCC Chairman as of 2024 is:', 'affairs', 'Ibrahim Magu', 'Abdulrasheed Bawa', 'Ola Olukoyede', 'Nuhu Ribadu', 2),
('Nigeria''s 2024 national budget was titled:', 'affairs', 'Budget of Consolidation', 'Budget of Renewed Hope', 'Budget of Renewal', 'Budget of Economic Restoration', 1),
('The CBN Governor appointed in 2023 is:', 'affairs', 'Godwin Emefiele', 'Yemi Cardoso', 'Kingsley Moghalu', 'Lamido Sanusi', 1),
('Nigeria officially joined which bloc as a full member in 2023?', 'affairs', 'BRICS', 'ECOWAS Free Trade Zone', 'African Continental Free Trade Area (AfCFTA)', 'Commonwealth Trade Alliance', 2),
('The "Renewed Hope Agenda" is associated with:', 'affairs', 'National Assembly', 'The Presidency under Bola Tinubu', 'The Judiciary', 'Federal Ministry of Finance', 1),
('Which country hosted the 2023 AFCON?', 'affairs', 'Nigeria', 'South Africa', 'Ivory Coast', 'Ghana', 2),
('Nigeria''s Naira exchange rate unification in 2023 was championed by:', 'affairs', 'The National Assembly', 'The CBN under new leadership', 'The Federal Ministry of Finance', 'The World Bank mission', 1),
('Which Nigerian state was created most recently (36th state)?', 'affairs', 'Zamfara', 'Ebonyi', 'Ekiti', 'Gombe', 2),
-- Education
('The body responsible for regulating basic and secondary education standards in Nigeria is:', 'edu', 'NUC', 'NBTE', 'NERDC', 'WAEC', 2),
('The UBE Act provides for how many years of free and compulsory education?', 'edu', '6 years', '8 years', '9 years', '10 years', 2),
('JAMB was established primarily to:', 'edu', 'Conduct WAEC examinations', 'Regulate university academic standards', 'Conduct unified admissions into tertiary institutions', 'Manage student bursaries', 2),
('The 6-3-3-4 system of education in Nigeria means:', 'edu', '6 primary, 3 JSS, 3 SSS, 4 university years', '6 primary, 3 middle school, 3 technical, 4 college', '6 nursery, 3 primary, 3 junior, 4 secondary', '6 primary, 3 JSS, 3 technical, 4 polytechnic', 0),
('The National Policy on Education in Nigeria was first published in:', 'edu', '1965', '1977', '1985', '1993', 1),
('Which body conducts the National Examination for primary school leavers in Nigeria?', 'edu', 'WAEC', 'JAMB', 'NECO', 'NERDC', 2),
('NUC is empowered to do all of the following EXCEPT:', 'edu', 'Grant university licences', 'Set minimum academic standards', 'Conduct JAMB UTME', 'Accredit academic programmes', 2),
('Under the Child''s Right Act, the minimum working age is:', 'edu', '12 years', '15 years', '16 years', '18 years', 1),
('TRCN was established to:', 'edu', 'Train teachers at federal colleges', 'Regulate and control the teaching profession', 'Set WAEC marking schemes', 'Manage UBEC funds', 1),
('UBEC disburses matching grants to states on what basis?', 'edu', 'Population of school-age children only', 'States must provide counterpart funding', 'Annual federal allocation automatically', 'Request from state governors only', 1),

-- ICT (10)
('What does "CPU" stand for in computing?', 'ict', 'Central Processing Unit', 'Computer Personal Unit', 'Central Program Utility', 'Core Processing Unit', 0),
('Which of the following is an example of an operating system?', 'ict', 'Microsoft Word', 'Google Chrome', 'Windows 11', 'Adobe Photoshop', 2),
('What does "WWW" stand for?', 'ict', 'World Wide Web', 'Wide World Web', 'World Web Wide', 'Web World Wide', 0),
('Which of the following is NOT a programming language?', 'ict', 'Python', 'Java', 'Linux', 'JavaScript', 2),
('What is the full meaning of "RAM" in computers?', 'ict', 'Random Access Memory', 'Read Access Memory', 'Rapid Application Memory', 'Remote Access Module', 0),
('Which device is used to connect a computer to the internet via a telephone line?', 'ict', 'Router', 'Hub', 'Modem', 'Switch', 2),
('What does "PDF" stand for?', 'ict', 'Portable Document Format', 'Printed Document File', 'Public Data Format', 'Personal Document Folder', 0),
('Which of the following is a search engine?', 'ict', 'Facebook', 'Twitter', 'Google', 'WhatsApp', 2),
('In Microsoft Excel, what symbol is used to begin a formula?', 'ict', '+', '#', '=', '@', 2),
('What is the storage capacity of 1 Gigabyte (GB)?', 'ict', '1,000 Kilobytes', '1,024 Megabytes', '512 Megabytes', '2,048 Kilobytes', 1),

-- Religion (10)
('How many books are in the Old Testament of the Christian Bible?', 'religion', '27', '39', '66', '46', 1),
('The holy book of Islam is called:', 'religion', 'The Torah', 'The Bible', 'The Quran', 'The Vedas', 2),
('In Islam, how many times a day are Muslims required to pray (Salat)?', 'religion', '3', '4', '5', '7', 2),
('Which river is considered the most sacred in Hinduism?', 'religion', 'Nile', 'Amazon', 'Ganges', 'Yangtze', 2),
('The first book of the Bible is:', 'religion', 'Exodus', 'Genesis', 'Leviticus', 'Numbers', 1),
('In Christianity, the period of fasting and prayer before Easter is called:', 'religion', 'Advent', 'Pentecost', 'Lent', 'Epiphany', 2),
('What is the meaning of "Islam" in Arabic?', 'religion', 'Peace', 'Submission', 'Faith', 'Prayer', 1),
('The Hijab worn by Muslim women is primarily a symbol of:', 'religion', 'Cultural identity', 'Modesty and piety', 'Political allegiance', 'Social status', 1),
('According to the Bible, Jesus Christ was baptised in which river?', 'religion', 'Nile', 'Euphrates', 'Jordan', 'Tigris', 2),
('The five pillars of Islam include all of the following EXCEPT:', 'religion', 'Salat (Prayer)', 'Hajj (Pilgrimage)', 'Zakat (Almsgiving)', 'Jihad (Struggle)', 3),

-- Common Entrance (10)
('What is the capital city of Nigeria?', 'entrance', 'Lagos', 'Kano', 'Abuja', 'Ibadan', 2),
('Which river is the longest in Nigeria?', 'entrance', 'Benue River', 'Niger River', 'Kaduna River', 'Cross River', 1),
('What is 15% of 200?', 'entrance', '20', '25', '30', '35', 2),
('Which of the following is a mammal?', 'entrance', 'Crocodile', 'Eagle', 'Whale', 'Tilapia', 2),
('How many sides does a hexagon have?', 'entrance', '5', '6', '7', '8', 1),
('What is the plural of "child"?', 'entrance', 'Childs', 'Childrens', 'Children', 'Child', 2),
('The process by which plants make their own food using sunlight is called:', 'entrance', 'Respiration', 'Photosynthesis', 'Digestion', 'Transpiration', 1),
('Which planet is closest to the Sun?', 'entrance', 'Venus', 'Earth', 'Mars', 'Mercury', 3),
('What is the sum of angles in a triangle?', 'entrance', '90°', '120°', '180°', '360°', 2),
('Who wrote the Nigerian national anthem "Arise O Compatriots"?', 'entrance', 'Wole Soyinka', 'A committee of Nigerians', 'Chinua Achebe', 'John Okafor', 1)
ON CONFLICT DO NOTHING;
