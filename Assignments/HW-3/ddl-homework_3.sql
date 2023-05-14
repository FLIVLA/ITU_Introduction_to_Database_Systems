CREATE TABLE person (
  person_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  phone_number TEXT NOT NULL,
  dob DATE NOT NULL,
  dod DATE
);

CREATE TABLE wasp_membership (
  person_id INTEGER REFERENCES person(person_id),
  start_date DATE NOT NULL,
  PRIMARY KEY (person_id)
);

CREATE TABLE wasp_enemy (
  person_id INTEGER REFERENCES person(person_id),
  reason TEXT NOT NULL,
  PRIMARY KEY (person_id)
);

CREATE TABLE asset (
  asset_name TEXT PRIMARY KEY,
  asset_description TEXT NOT NULL,
  asset_usage TEXT NOT NULL
);

CREATE TABLE person_asset (
  person_id INTEGER REFERENCES person(person_id),
  asset_name TEXT REFERENCES asset(asset_name),
  PRIMARY KEY (person_id, asset_name)
);

CREATE TABLE linking_type (
  linking_type_id SERIAL PRIMARY KEY,
  linking_type_title TEXT NOT NULL,
  linking_type_description TEXT NOT NULL
);

CREATE TABLE linking (
  linking_id SERIAL PRIMARY KEY,
  linking_name TEXT NOT NULL,
  linking_type_id INTEGER REFERENCES linking_type(linking_type_id),
  linking_description TEXT NOT NULL
);

CREATE TABLE linking_participation (
  person_id INTEGER REFERENCES person(person_id),
  linking_id INTEGER REFERENCES linking(linking_id),
  monitoring_member_id INTEGER REFERENCES wasp_membership(person_id),
  PRIMARY KEY (person_id, linking_id)
);

CREATE TABLE role (
  role_id SERIAL PRIMARY KEY,
  role_title TEXT NOT NULL,
  monthly_salary NUMERIC(10,2) NOT NULL
);

CREATE TABLE role_assignment (
  role_id INTEGER REFERENCES role(role_id),
  person_id INTEGER REFERENCES wasp_membership(person_id),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  PRIMARY KEY (role_id, start_date)
);

CREATE TABLE political_party (
  party_id SERIAL PRIMARY KEY,
  party_name TEXT NOT NULL,
  party_country TEXT NOT NULL,
  UNIQUE(party_name, party_country)
);

CREATE TABLE party_monitoring (
  party_id INTEGER REFERENCES political_party(party_id),
  member_id INTEGER REFERENCES wasp_membership(person_id),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  PRIMARY KEY (party_id, start_date)
);

CREATE TABLE sponsor (
  sponsor_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  industry TEXT NOT NULL
);

CREATE TABLE grants (
  grant_id SERIAL PRIMARY KEY,
  sponsor_id INTEGER REFERENCES sponsor(sponsor_id),
  recipient_id INTEGER REFERENCES wasp_membership(person_id),
  grant_date DATE NOT NULL,
  grant_amount NUMERIC(10,2) NOT NULL,
  payback TEXT NOT NULL,
  review_date DATE NOT NULL,
  review_grade INTEGER NOT NULL CHECK (review_grade BETWEEN 1 AND 10)
);

CREATE TABLE opponent (
  opponent_id SERIAL PRIMARY KEY
);

CREATE TABLE opposition (
  opponent_id INTEGER REFERENCES opponent(opponent_id),
  member_id INTEGER REFERENCES wasp_membership(person_id),
  start_date DATE NOT NULL,
  end_date DATE,
  PRIMARY KEY (opponent_id, member_id, start_date)
);