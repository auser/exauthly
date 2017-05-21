--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE auth_tokens (
    jti character varying(255) NOT NULL,
    aud character varying(255) NOT NULL,
    typ character varying(255),
    iss character varying(255),
    sub character varying(255),
    exp bigint,
    jwt text,
    claims jsonb,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: authorizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE authorizations (
    id integer NOT NULL,
    provider character varying(255),
    uid character varying(255),
    user_id integer NOT NULL,
    token character varying(255),
    refresh_token character varying(255),
    expires_at bigint,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: authorizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE authorizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authorizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE authorizations_id_seq OWNED BY authorizations.id;


--
-- Name: organization_memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE organization_memberships (
    id integer NOT NULL,
    role character varying(255) NOT NULL,
    organization_id integer NOT NULL,
    member_id integer NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: organization_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organization_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organization_memberships_id_seq OWNED BY organization_memberships.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE organizations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying(255)
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organizations_id_seq OWNED BY organizations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


--
-- Name: stripe_connect_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE stripe_connect_accounts (
    id integer NOT NULL,
    business_name character varying(255),
    business_url character varying(255),
    charges_enabled boolean DEFAULT true NOT NULL,
    country character varying(255),
    default_currency character varying(255) DEFAULT 'USD'::character varying,
    display_name character varying(255),
    email character varying(255),
    stripe_id character varying(255) NOT NULL,
    support_email character varying(255),
    support_phone character varying(255),
    tos_acceptance_date timestamp without time zone,
    verification_due_by timestamp without time zone,
    organization_id integer NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: stripe_connect_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stripe_connect_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stripe_connect_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stripe_connect_accounts_id_seq OWNED BY stripe_connect_accounts.id;


--
-- Name: stripe_external_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE stripe_external_accounts (
    id integer NOT NULL,
    stripe_id character varying(255),
    account_id_from_stripe character varying(255),
    account_holder_name character varying(255),
    account_holder_type character varying(255),
    bank_name character varying(255),
    country character varying(255),
    currency character varying(255),
    fingerprint character varying(255),
    last4 character varying(255),
    routing_number character varying(255),
    status character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: stripe_external_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stripe_external_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stripe_external_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stripe_external_accounts_id_seq OWNED BY stripe_external_accounts.id;


--
-- Name: stripe_platform_customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE stripe_platform_customers (
    id integer NOT NULL,
    currency character varying(255),
    delinquent boolean DEFAULT false NOT NULL,
    email character varying(255),
    stripe_id character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: stripe_platform_customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stripe_platform_customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stripe_platform_customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stripe_platform_customers_id_seq OWNED BY stripe_platform_customers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255) NOT NULL,
    password character varying(255),
    encrypted_password character varying(255),
    password_reset_token character varying(255),
    password_reset_timestamp timestamp without time zone,
    admin boolean DEFAULT false,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    current_organization_id integer,
    role character varying(255) DEFAULT 'user'::character varying,
    verified boolean DEFAULT false,
    verify_token character varying(255)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: authorizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY authorizations ALTER COLUMN id SET DEFAULT nextval('authorizations_id_seq'::regclass);


--
-- Name: organization_memberships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organization_memberships ALTER COLUMN id SET DEFAULT nextval('organization_memberships_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq'::regclass);


--
-- Name: stripe_connect_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stripe_connect_accounts ALTER COLUMN id SET DEFAULT nextval('stripe_connect_accounts_id_seq'::regclass);


--
-- Name: stripe_external_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stripe_external_accounts ALTER COLUMN id SET DEFAULT nextval('stripe_external_accounts_id_seq'::regclass);


--
-- Name: stripe_platform_customers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stripe_platform_customers ALTER COLUMN id SET DEFAULT nextval('stripe_platform_customers_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: auth_tokens auth_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_tokens
    ADD CONSTRAINT auth_tokens_pkey PRIMARY KEY (jti, aud);


--
-- Name: authorizations authorizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY authorizations
    ADD CONSTRAINT authorizations_pkey PRIMARY KEY (id);


--
-- Name: organization_memberships organization_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY organization_memberships
    ADD CONSTRAINT organization_memberships_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: stripe_connect_accounts stripe_connect_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stripe_connect_accounts
    ADD CONSTRAINT stripe_connect_accounts_pkey PRIMARY KEY (id);


--
-- Name: stripe_external_accounts stripe_external_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stripe_external_accounts
    ADD CONSTRAINT stripe_external_accounts_pkey PRIMARY KEY (id);


--
-- Name: stripe_platform_customers stripe_platform_customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stripe_platform_customers
    ADD CONSTRAINT stripe_platform_customers_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: authorizations_expires_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX authorizations_expires_at_index ON authorizations USING btree (expires_at);


--
-- Name: authorizations_provider_token_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX authorizations_provider_token_index ON authorizations USING btree (provider, token);


--
-- Name: authorizations_provider_uid_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX authorizations_provider_uid_index ON authorizations USING btree (provider, uid);


--
-- Name: organization_memberships_member_id_organization_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX organization_memberships_member_id_organization_id_index ON organization_memberships USING btree (member_id, organization_id);


--
-- Name: organizations_lower_slug_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX organizations_lower_slug_index ON organizations USING btree (lower((slug)::text));


--
-- Name: organizations_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX organizations_name_index ON organizations USING btree (name);


--
-- Name: stripe_connect_accounts_organization_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX stripe_connect_accounts_organization_id_index ON stripe_connect_accounts USING btree (organization_id);


--
-- Name: stripe_connect_accounts_stripe_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX stripe_connect_accounts_stripe_id_index ON stripe_connect_accounts USING btree (stripe_id);


--
-- Name: users_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_email_index ON users USING btree (email);


--
-- Name: users_role_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_role_index ON users USING btree (role);


--
-- Name: users_verify_token_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_verify_token_index ON users USING btree (verify_token);


--
-- Name: authorizations authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY authorizations
    ADD CONSTRAINT authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: organization_memberships organization_memberships_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY organization_memberships
    ADD CONSTRAINT organization_memberships_member_id_fkey FOREIGN KEY (member_id) REFERENCES users(id);


--
-- Name: organization_memberships organization_memberships_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY organization_memberships
    ADD CONSTRAINT organization_memberships_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES organizations(id);


--
-- Name: stripe_connect_accounts stripe_connect_accounts_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stripe_connect_accounts
    ADD CONSTRAINT stripe_connect_accounts_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES organizations(id);


--
-- Name: users users_current_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_current_organization_id_fkey FOREIGN KEY (current_organization_id) REFERENCES organizations(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO "schema_migrations" (version) VALUES (20170410060725), (20170412165633), (20170412165641), (20170413013317), (20170420213358), (20170420220929), (20170505195151), (20170518011034), (20170520002725), (20170520003440), (20170520030045), (20170520044655);

