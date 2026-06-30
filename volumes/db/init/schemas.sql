\set pgpass `echo "$POSTGRES_PASSWORD"`

CREATE USER studio WITH PASSWORD :'pgpass';
CREATE USER webui WITH PASSWORD :'pgpass';

CREATE EXTENSION IF NOT EXISTS vector SCHEMA extensions;
CREATE SCHEMA studio AUTHORIZATION studio;
GRANT USAGE, CREATE ON SCHEMA studio TO postgres, anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA studio GRANT ALL ON TABLES TO postgres, anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA studio GRANT ALL ON FUNCTIONS TO postgres, anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA studio GRANT ALL ON SEQUENCES TO postgres, anon, authenticated, service_role;
ALTER USER studio SET search_path TO studio, extensions, public;

-- Allow postgres role to create objects in the schema

GRANT USAGE, CREATE ON SCHEMA studio TO postgres;

-- Ensure postgres has privileges on any existing objects in the schema

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA studio TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA studio TO postgres;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA studio TO postgres;

CREATE SCHEMA webui AUTHORIZATION webui;
GRANT USAGE, CREATE ON SCHEMA webui TO postgres, anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA webui GRANT ALL ON TABLES TO postgres, anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA webui GRANT ALL ON FUNCTIONS TO postgres, anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA webui GRANT ALL ON SEQUENCES TO postgres, anon, authenticated, service_role;
ALTER USER webui SET search_path TO webui, extensions, public;

-- Allow postgres role to create objects in the schema

GRANT USAGE, CREATE ON SCHEMA webui TO postgres;

-- Ensure postgres has privileges on any existing objects in the schema

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA webui TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA webui TO postgres;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA webui TO postgres;

GRANT USAGE ON SCHEMA extensions TO studio, webui;

CREATE SCHEMA private AUTHORIZATION postgres;
GRANT USAGE, CREATE ON SCHEMA private TO postgres;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA private TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA private TO postgres;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA private TO postgres;

-- =========================================================
-- OWNERS Y PERMISOS BASE DE SCHEMAS
-- =========================================================

ALTER SCHEMA public OWNER TO postgres;
ALTER SCHEMA private OWNER TO postgres;
ALTER SCHEMA studio OWNER TO studio;
ALTER SCHEMA webui OWNER TO webui;

GRANT USAGE, CREATE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT USAGE, CREATE ON SCHEMA private TO postgres;
GRANT USAGE, CREATE ON SCHEMA studio TO postgres, studio, anon, authenticated, service_role;
GRANT USAGE, CREATE ON SCHEMA webui TO postgres, webui, anon, authenticated, service_role;

-- =========================================================
-- PERMISOS SOBRE OBJETOS EXISTENTES
-- =========================================================

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO postgres, anon, authenticated, service_role;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA private TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA private TO postgres;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA private TO postgres;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA studio TO postgres, studio, anon, authenticated, service_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA studio TO postgres, studio, anon, authenticated, service_role;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA studio TO postgres, studio, anon, authenticated, service_role;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA webui TO postgres, webui, anon, authenticated, service_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA webui TO postgres, webui, anon, authenticated, service_role;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA webui TO postgres, webui, anon, authenticated, service_role;

-- =========================================================
-- DEFAULT PRIVILEGES PARA OBJETOS FUTUROS
-- =========================================================

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
GRANT ALL PRIVILEGES ON TABLES TO postgres, anon, authenticated, service_role;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
GRANT ALL PRIVILEGES ON SEQUENCES TO postgres, anon, authenticated, service_role;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
GRANT ALL PRIVILEGES ON FUNCTIONS TO postgres, anon, authenticated, service_role;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA private
GRANT ALL PRIVILEGES ON TABLES TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA private
GRANT ALL PRIVILEGES ON SEQUENCES TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA private
GRANT ALL PRIVILEGES ON FUNCTIONS TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE studio IN SCHEMA studio
GRANT ALL PRIVILEGES ON TABLES TO postgres, studio, anon, authenticated, service_role;

ALTER DEFAULT PRIVILEGES FOR ROLE studio IN SCHEMA studio
GRANT ALL PRIVILEGES ON SEQUENCES TO postgres, studio, anon, authenticated, service_role;

ALTER DEFAULT PRIVILEGES FOR ROLE studio IN SCHEMA studio
GRANT ALL PRIVILEGES ON FUNCTIONS TO postgres, studio, anon, authenticated, service_role;

ALTER DEFAULT PRIVILEGES FOR ROLE webui IN SCHEMA webui
GRANT ALL PRIVILEGES ON TABLES TO postgres, webui, anon, authenticated, service_role;

ALTER DEFAULT PRIVILEGES FOR ROLE webui IN SCHEMA webui
GRANT ALL PRIVILEGES ON SEQUENCES TO postgres, webui, anon, authenticated, service_role;

ALTER DEFAULT PRIVILEGES FOR ROLE webui IN SCHEMA webui
GRANT ALL PRIVILEGES ON FUNCTIONS TO postgres, webui, anon, authenticated, service_role;

GRANT USAGE, CREATE ON SCHEMA public TO studio;

-- =========================================================
-- POSTGRES
-- =========================================================
SET ROLE postgres;

  CREATE TABLE "public"."tenants" (
      "idTenant" int4 GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
      email varchar(100) NOT NULL,
      plan varchar(100) DEFAULT 'trial'::character varying NULL,
      payment bool DEFAULT false NULL,
      company varchar(100) NULL,
      "idSubscription" varchar(100) NULL,
      disclaimer bool DEFAULT false NULL,
      "createdAt" timestamp DEFAULT now() NULL,
      "updatedUser" varchar(100) NULL,
      "updatedAt" timestamp NULL,
      sincro bool DEFAULT false NOT NULL,
      "interval" text NULL,
      "customerId" text NULL,
      "paymentDate" timestamp NULL,
      settings jsonb NULL,
      CONSTRAINT tenants_pkey PRIMARY KEY ("idTenant")
  );
      
  CREATE TABLE "public"."users" (
      id uuid NOT NULL,
      email text NULL,
      first_name text NULL,
      last_name text NULL,
      id_tenantint int4 NULL,
      phone text NULL,
      country text NULL,
      company text NULL,
      imgurl text NULL,
      "role" text DEFAULT 'user'::text NULL,
      status bool DEFAULT true NULL,
      settings jsonb NULL,
      CONSTRAINT users_pkey PRIMARY KEY (id)
  );

  CREATE TABLE "public"."teams" (
      id uuid DEFAULT gen_random_uuid() NOT NULL,
      "createdAt" timestamptz DEFAULT now() NOT NULL,
      "name" varchar NULL,
      description varchar NULL,
      "imageUrl" varchar NULL,
      "idTenant" int4 NULL,
      sincro bool DEFAULT false NOT NULL,
      visible bool DEFAULT true NULL,
      CONSTRAINT teams_pkey PRIMARY KEY (id),
      CONSTRAINT teams_idtenant_fkey FOREIGN KEY ("idTenant") REFERENCES public.tenants("idTenant") ON DELETE CASCADE
  );

  CREATE TABLE "public"."teamsecurityuser" (
      id uuid DEFAULT gen_random_uuid() NOT NULL,
      created_at timestamptz DEFAULT now() NOT NULL,
      team uuid NULL,
      "user" uuid NULL,
      tenant int4 NULL,
      "role" text NULL,
      "member" bool NULL,
      CONSTRAINT teamsecurityuser_pkey PRIMARY KEY (id),
      CONSTRAINT teamsecurityuser_team_fkey FOREIGN KEY (team) REFERENCES public.teams(id) ON DELETE CASCADE ON UPDATE CASCADE,
      CONSTRAINT teamsecurityuser_tenant_fkey FOREIGN KEY (tenant) REFERENCES public.tenants("idTenant"),
      CONSTRAINT teamsecurityuser_user_fkey FOREIGN KEY ("user") REFERENCES public.users(id) ON DELETE CASCADE ON UPDATE CASCADE
  );

  CREATE TABLE "public"."aibot" (
      "idBot" int4 GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
      "idTenant" int4 NOT NULL,
      "name" varchar(50) NOT NULL,
      description varchar(500) NULL,
      "createdUser" uuid NULL,
      "createdAt" timestamp DEFAULT now() NULL,
      "updatedUser" varchar(100) NULL,
      "updatedAt" timestamp NULL,
      disabled bool DEFAULT false NULL,
      team uuid NULL,
      "imageUrl" varchar NULL,
      "type" text NULL,
      "messageInitial" text DEFAULT 'Hola ¿Como puedo ayudarte?'::text NULL,
      deleted bool DEFAULT false NULL,
      botpublic bool DEFAULT false NOT NULL,
      settings jsonb NULL,
      CONSTRAINT aibot_pkey PRIMARY KEY ("idBot"),
      CONSTRAINT aibot_createduser_fkey FOREIGN KEY ("createdUser") REFERENCES public.users(id),
      CONSTRAINT aibot_idtenant_fkey FOREIGN KEY ("idTenant") REFERENCES public.tenants("idTenant") ON DELETE CASCADE,
      CONSTRAINT aibot_team_fkey FOREIGN KEY (team) REFERENCES public.teams(id) ON DELETE CASCADE
  );

  CREATE TABLE "public"."databases" (
      id int4 GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
      "name" text NOT NULL,
      host text NULL,
      "user" text NULL,
      port text NULL,
      "password" text NULL,
      "schema" text NULL,
      "type" text NULL,
      "role" text NULL,
      address text NULL,
      serviceaccount jsonb NULL,
      projectid text NULL,
      datasetid text NULL,
      CONSTRAINT dbdatos_pkey PRIMARY KEY (id),
      CONSTRAINT databases_id_fkey FOREIGN KEY (id) REFERENCES public.aibot("idBot") ON DELETE CASCADE ON UPDATE CASCADE
  );

  CREATE TABLE "public"."document" (
      id uuid DEFAULT gen_random_uuid() NOT NULL,
      "createdAt" timestamptz DEFAULT now() NOT NULL,
      description varchar NULL,
      "createdBy" varchar NULL,
      "name" varchar NULL,
      "idBot" int4 NULL,
      "nameReal" varchar NULL,
      "idVectors" text NULL,
      "docCreationDate" timestamptz NULL,
      "docModifiedDate" timestamptz NULL,
      CONSTRAINT document_pkey PRIMARY KEY (id),
      CONSTRAINT document_idbot_fkey FOREIGN KEY ("idBot") REFERENCES public.aibot("idBot") ON DELETE CASCADE
  );

  CREATE TABLE "public"."documents" (
      id uuid NOT NULL,
      "content" text NULL,
      metadata jsonb NULL,
      embedding extensions.vector NULL,
      CONSTRAINT documents_pkey PRIMARY KEY (id)
  );

  CREATE TABLE "public"."history" (
      "createdAt" timestamptz DEFAULT now() NOT NULL,
      "idUser" uuid NOT NULL,
      "idBot" int4 NOT NULL,
      created text NULL,
      message text NULL,
      id int4 GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
      dataframe jsonb NULL,
      qualification bool NULL,
      metadata jsonb NULL,
      CONSTRAINT history_pkey PRIMARY KEY ("idUser", "idBot", id),
      CONSTRAINT pruebachat_id_key UNIQUE (id),
      CONSTRAINT "public_history_idBot_fkey" FOREIGN KEY ("idBot") REFERENCES public.aibot("idBot") ON DELETE CASCADE ON UPDATE CASCADE,
      CONSTRAINT "public_history_idUser_fkey" FOREIGN KEY ("idUser") REFERENCES public.users(id) ON DELETE CASCADE ON UPDATE CASCADE
  );

  CREATE TABLE "public"."roles" (
      id uuid DEFAULT gen_random_uuid() NOT NULL,
      tenantid int4 NOT NULL,
      "name" text NOT NULL,
      description text NULL,
      created_at timestamptz DEFAULT now() NOT NULL,
      updated_at timestamptz NULL,
      CONSTRAINT roles_name_key UNIQUE (name),
      CONSTRAINT roles_pkey PRIMARY KEY (id),
      CONSTRAINT roles_tenantid_fkey FOREIGN KEY (tenantid) REFERENCES public.tenants("idTenant") ON DELETE CASCADE
  );

  CREATE TABLE "public"."role_permissions" (
      id uuid DEFAULT gen_random_uuid() NOT NULL,
      role_id uuid NOT NULL,
      "permission" text NOT NULL,
      created_at timestamptz DEFAULT now() NOT NULL,
      updated_at timestamptz NULL,
      CONSTRAINT permissions_pkey PRIMARY KEY (id),
      CONSTRAINT permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE
  );

  CREATE TABLE "public"."tenant_plans" (
      id int8 GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
      "idTenant" int4 NOT NULL,
      "planName" text NOT NULL,
      "maxMessages" int4 NULL,
      "studioIntegrated" bool DEFAULT false NOT NULL,
      "periodStartAt" timestamptz NOT NULL,
      "expiresAt" timestamptz NULL,
      "validatedAt" timestamptz NULL,
      status text DEFAULT 'active'::text NOT NULL,
      "createdAt" timestamptz DEFAULT now() NOT NULL,
      "updatedAt" timestamptz DEFAULT now() NOT NULL,
      CONSTRAINT tenant_plans_idtenant_key UNIQUE ("idTenant"),
      CONSTRAINT tenant_plans_pkey PRIMARY KEY (id),
      CONSTRAINT tenant_plans_tenant_fkey FOREIGN KEY ("idTenant") REFERENCES public.tenants("idTenant") ON DELETE CASCADE
  );

  CREATE INDEX tenant_plans_idtenant_idx ON public.tenant_plans USING btree ("idTenant");

  CREATE INDEX tenant_plans_status_idx ON public.tenant_plans USING btree (status);

  CREATE TABLE "public"."tenant_license_activations" (
      id int8 GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
      "idTenant" int4 NOT NULL,
      "rawPayload" text NOT NULL,
      "licenseBundle" jsonb NOT NULL,
      "activationRequest" jsonb NOT NULL,
      "activationResponse" jsonb NOT NULL,
      "mode" text NULL,
      "productCode" text NULL,
      "customerId" text NULL,
      "planName" text NULL,
      jti text NULL,
      kid text NULL,
      "totalDays" int4 NULL,
      "expiresAt" timestamptz NULL,
      "validatedAt" timestamptz NULL,
      "source" text NULL,
      warning text NULL,
      status text DEFAULT 'active'::text NOT NULL,
      "uploadedFilename" text NULL,
      "createdAt" timestamptz DEFAULT now() NOT NULL,
      "updatedAt" timestamptz DEFAULT now() NOT NULL,
      CONSTRAINT tenant_license_activations_idtenant_key UNIQUE ("idTenant"),
      CONSTRAINT tenant_license_activations_pkey PRIMARY KEY (id),
      CONSTRAINT tenant_license_activations_tenant_fkey FOREIGN KEY ("idTenant") REFERENCES public.tenants("idTenant") ON DELETE CASCADE
  );

  CREATE INDEX tenant_license_activations_idtenant_idx ON public.tenant_license_activations USING btree ("idTenant");

  CREATE TABLE "public"."tenant_license_activation_attempts" (
      id int8 GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
      "idTenant" int4 NOT NULL,
      "rawPayload" text NULL,
      "licenseBundle" jsonb NULL,
      "activationRequest" jsonb NULL,
      "activationResponse" jsonb NULL,
      "httpStatus" int4 NULL,
      "errorCode" text NULL,
      "errorMessage" text NULL,
      status text NOT NULL,
      "uploadedFilename" text NULL,
      "createdAt" timestamptz DEFAULT now() NOT NULL,
      "updatedAt" timestamptz DEFAULT now() NOT NULL,
      CONSTRAINT tenant_license_activation_attempts_pkey PRIMARY KEY (id),
      CONSTRAINT tenant_license_activation_attempts_tenant_fkey FOREIGN KEY ("idTenant") REFERENCES public.tenants("idTenant") ON DELETE CASCADE
  );

  CREATE INDEX tenant_license_activation_attempts_idtenant_createdat_idx ON public.tenant_license_activation_attempts USING btree ("idTenant", "createdAt" DESC);

  CREATE TABLE "public"."training" (
      question_id int4 NULL,
      answer_id int4 NOT NULL,
      id_bot int4 NULL,
      question text NULL,
      answer text NULL,
      question_created timestamptz NULL,
      answer_created timestamptz NULL,
      CONSTRAINT training_pkey PRIMARY KEY (answer_id)
  );

  -- Table Triggers

  -- Table Triggers

  -- Table Triggers

  alter table "public"."aibot" enable row level security;
  alter table "public"."databases" enable row level security;
  alter table "public"."document" enable row level security;
  alter table "public"."documents" enable row level security;
  alter table "public"."history" enable row level security;
  alter table "public"."role_permissions" enable row level security;
  alter table "public"."roles" enable row level security;
  alter table "public"."teams" enable row level security;
  alter table "public"."teamsecurityuser" enable row level security;
  alter table "public"."tenants" enable row level security;
  alter table "public"."training" enable row level security;
  alter table "public"."users" enable row level security;
  alter table "public"."tenant_plans" enable row level security;
  alter table "public"."tenant_license_activations" enable row level security;
  alter table "public"."tenant_license_activation_attempts" enable row level security;

  CREATE POLICY "Enable all access for all users" ON "public"."aibot" TO "postgres", "authenticated", "service_role" USING (true) WITH CHECK (true);
  CREATE POLICY "Enable all access for all users" ON "public"."databases" TO "postgres", "authenticated", "service_role" USING (true) WITH CHECK (true);
  CREATE POLICY "Enable all access for all users" ON "public"."document" TO "postgres", "authenticated", "service_role" USING (true) WITH CHECK (true);
  CREATE POLICY "Enable all access for all users" ON "public"."documents" TO "postgres", "authenticated", "service_role" USING (true) WITH CHECK (true);
  CREATE POLICY "Enable all access for all users" ON "public"."history" TO "postgres", "authenticated", "service_role" USING (true) WITH CHECK (true);
  CREATE POLICY "Enable all access for all users" ON "public"."role_permissions" TO "postgres", "authenticated", "service_role" USING (true) WITH CHECK (true);
  CREATE POLICY "Enable all access for all users" ON "public"."roles" TO "postgres", "authenticated", "service_role" USING (true) WITH CHECK (true);
  CREATE POLICY "Enable all access for all users" ON "public"."teams" TO "postgres", "authenticated", "service_role" USING (true) WITH CHECK (true);
  CREATE POLICY "Enable all access for all users" ON "public"."teamsecurityuser" TO "postgres", "authenticated", "service_role" USING (true) WITH CHECK (true);
  CREATE POLICY "Enable all access for all users" ON "public"."tenants" TO "postgres", "authenticated", "service_role" USING (true) WITH CHECK (true);
  CREATE POLICY "Enable all access for all users" ON "public"."training" TO "postgres", "authenticated", "service_role" USING (true) WITH CHECK (true);
  CREATE POLICY "Enable all access for all users" ON "public"."users" TO "postgres", "authenticated", "service_role" USING (true) WITH CHECK (true);
  CREATE POLICY "Enable all access for all users" ON "public"."tenant_plans" TO "postgres", "authenticated", "service_role" USING (true) WITH CHECK (true);
  CREATE POLICY "Enable all access for all users" ON "public"."tenant_license_activations" TO "postgres", "authenticated", "service_role" USING (true) WITH CHECK (true);
  CREATE POLICY "Enable all access for all users" ON "public"."tenant_license_activation_attempts" TO "postgres", "authenticated", "service_role" USING (true) WITH CHECK (true);


RESET ROLE;

-- =========================================================
-- STUDIO
-- =========================================================
SET ROLE studio;
  -- 1. Tablas sin dependencias fuertes
  create table studio.chat_message (
    id uuid not null default extensions.uuid_generate_v4 (),
    role character varying not null,
    chatflowid uuid not null,
    content text not null,
    "sourceDocuments" text null,
    "createdDate" timestamp without time zone not null default now(),
    "chatType" character varying not null default 'INTERNAL'::character varying,
    "chatId" character varying not null,
    "memoryType" character varying null,
    "sessionId" character varying null,
    "usedTools" text null,
    "fileAnnotations" text null,
    "fileUploads" text null,
    "leadEmail" text null,
    "agentReasoning" text null,
    action text null,
    artifacts text null,
    "followUpPrompts" text null,
    "executionId" uuid null,
    "reasonContent" text null,
    constraint PK_3cc0d85193aade457d3077dd06b primary key (id)
  ) TABLESPACE pg_default;
  create index IF not exists "IDX_e574527322272fd838f4f0f3d3" on studio.chat_message using btree (chatflowid) TABLESPACE pg_default;
  create index IF not exists "IDX_f56c36fe42894d57e5c664d229" on studio.chat_message using btree (chatflowid) TABLESPACE pg_default;

  CREATE  TABLE studio.chat_message_feedback (
    id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    chatflowid uuid NOT NULL,
    content text NULL,
    "chatId" character varying NOT NULL,
    "messageId" uuid NOT NULL,
    rating character varying NOT NULL,
    "createdDate" timestamp without time zone NOT NULL DEFAULT now(),
    CONSTRAINT "PK_98419043dd704f54-9830ab78f9" PRIMARY KEY (id),
    CONSTRAINT "UQ_6352078b5a294f2d22179ea7956" UNIQUE ("messageId")
  ) TABLESPACE pg_default;
  CREATE INDEX IF NOT EXISTS "IDX_f56c36fe42894d57e5c664d230" ON studio.chat_message_feedback USING btree (chatflowid) TABLESPACE pg_default;
  CREATE INDEX IF NOT EXISTS "IDX_9acddcb7a2b51fe37669049fc6" ON studio.chat_message_feedback USING btree ("chatId") TABLESPACE pg_default;

  create table studio.custom_mcp_server (
    id uuid not null default extensions.uuid_generate_v4 (),
    name character varying not null,
    "serverUrl" text not null,
    "iconSrc" character varying null,
    color character varying null,
    "authType" character varying not null default 'NONE'::character varying,
    "authConfig" text null,
    tools text null,
    "toolCount" integer not null default 0,
    status character varying not null default 'PENDING'::character varying,
    "createdDate" timestamp without time zone not null default now(),
    "updatedDate" timestamp without time zone not null default now(),
    "workspaceId" text not null,
    constraint PK_custom_mcp_server_id primary key (id)
  ) TABLESPACE pg_default;
  create index IF not exists "IDX_custom_mcp_workspace_updated" on studio.custom_mcp_server using btree ("workspaceId", "updatedDate") TABLESPACE pg_default;

  CREATE  TABLE studio.dataset_row (
    id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "datasetId" character varying NOT NULL,
    input text NOT NULL,
    output text NULL,
    "updatedDate" timestamp without time zone NOT NULL DEFAULT now(),
    sequence_no integer NULL DEFAULT '-1'::integer,
    CONSTRAINT "PK_98909027dd804f54-9840ab99f8" PRIMARY KEY (id)
  ) TABLESPACE pg_default;

  CREATE  TABLE studio.document_store_file_chunk (
    id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "docId" uuid NOT NULL,
    "chunkNo" integer NOT NULL,
    "storeId" uuid NOT NULL,
    "pageContent" text NULL,
    metadata text NULL,
    CONSTRAINT "PK_90005043dd774f54-9830ab78f9" PRIMARY KEY (id)
  ) TABLESPACE pg_default;
  CREATE INDEX IF NOT EXISTS "IDX_e76bae1780b77e56aab1h2asd4" ON studio.document_store_file_chunk USING btree ("docId") TABLESPACE pg_default;
  CREATE INDEX IF NOT EXISTS "IDX_e213b811b01405a42309a6a410" ON studio.document_store_file_chunk USING btree ("storeId") TABLESPACE pg_default;

  CREATE  TABLE studio.evaluation_run (
    id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "evaluationId" character varying NOT NULL,
    input text NOT NULL,
    "expectedOutput" text NULL,
    "actualOutput" text NULL,
    evaluators text NULL,
    "llmEvaluators" text NULL,
    metrics text NULL,
    "runDate" timestamp without time zone NOT NULL DEFAULT now(),
    errors text NULL DEFAULT '[]'::text,
    CONSTRAINT "PK_98989927dd804f54-9840ab23f8" PRIMARY KEY (id)
  ) TABLESPACE pg_default;

  CREATE  TABLE studio.lead (
    id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    chatflowid character varying NOT NULL,
    "chatId" character varying NOT NULL,
    name text NULL,
    email text NULL,
    phone text NULL,
    "createdDate" timestamp without time zone NOT NULL DEFAULT now(),
    CONSTRAINT "PK_98419043dd704f54-9830ab78f0" PRIMARY KEY (id)
  ) TABLESPACE pg_default;

  create table studio.login_activity (
    id uuid not null default extensions.uuid_generate_v4 (),
    username character varying not null,
    activity_code integer not null,
    message character varying not null,
    "attemptedDateTime" timestamp without time zone not null default now(),
    login_mode character varying null
  ) TABLESPACE pg_default;

  create table studio.migrations (
    id serial not null,
    timestamp bigint not null,
    name character varying not null,
    constraint "PK_8c82d7f526340ab734260ea46be" primary key (id)
  ) TABLESPACE pg_default;

  create table studio.upsert_history (
    id uuid not null default extensions.uuid_generate_v4 (),
    chatflowid character varying not null,
    result text not null,
    "flowData" text not null,
    date timestamp without time zone not null default now(),
    constraint "PK_37327b22b6e246319bd5eeb0e88" primary key (id)
  ) TABLESPACE pg_default;

  create table studio.upsertion_records (
    uuid uuid not null default gen_random_uuid (),
    key text not null,
    namespace text not null,
    updated_at double precision not null,
    group_id text null,
    doc_id text null,
    constraint upsertion_records_pkey primary key (uuid),
    constraint upsertion_records_key_namespace_key unique (key, namespace)
  ) TABLESPACE pg_default;
  create index IF not exists updated_at_index on studio.upsertion_records using btree (updated_at) TABLESPACE pg_default;
  create index IF not exists key_index on studio.upsertion_records using btree (key) TABLESPACE pg_default;
  create index IF not exists namespace_index on studio.upsertion_records using btree (namespace) TABLESPACE pg_default;
  create index IF not exists group_id_index on studio.upsertion_records using btree (group_id) TABLESPACE pg_default;
  create index IF not exists doc_id_index on studio.upsertion_records using btree (doc_id) TABLESPACE pg_default;

  -- 2. Usuario base
  create table studio.user (
    id uuid not null default extensions.uuid_generate_v4 (),
    name character varying(100) not null,
    email character varying(255) not null,
    credential text null,
    "tempToken" text null,
    "tokenExpiry" timestamp without time zone null,
    status character varying(20) not null default 'unverified'::character varying,
    "createdDate" timestamp without time zone not null default now(),
    "updatedDate" timestamp without time zone not null default now(),
    "createdBy" uuid not null,
    "updatedBy" uuid not null,
    constraint user_pkey primary key (id),
    constraint user_email_key unique (email),
    constraint fk_createdBy foreign KEY ("createdBy") references studio."user" (id),
    constraint fk_updatedBy foreign KEY ("updatedBy") references studio."user" (id)
  ) TABLESPACE pg_default;

  -- 3. Organización
  create table studio.organization (
    id uuid not null default extensions.uuid_generate_v4 (),
    name character varying(100) not null default 'Default Organization'::character varying,
    "customerId" character varying(100) null,
    "subscriptionId" character varying(100) null,
    "createdDate" timestamp without time zone not null default now(),
    "updatedDate" timestamp without time zone not null default now(),
    "createdBy" uuid not null,
    "updatedBy" uuid not null,
    constraint organization_pkey primary key (id),
    constraint fk_createdBy foreign KEY ("createdBy") references studio."user" (id),
    constraint fk_updatedBy foreign KEY ("updatedBy") references studio."user" (id)
  ) TABLESPACE pg_default;

  -- 4. Tablas que dependen de user / organization
  create table studio.login_method (
    id uuid not null default extensions.uuid_generate_v4 (),
    "organizationId" uuid null,
    name character varying(100) not null,
    config text not null,
    status character varying(20) not null default 'enable'::character varying,
    "createdDate" timestamp without time zone not null default now(),
    "updatedDate" timestamp without time zone not null default now(),
    "createdBy" uuid null,
    "updatedBy" uuid null,
    constraint login_method_pkey primary key (id),
    constraint fk_organizationId foreign KEY ("organizationId") references studio.organization (id),
    constraint fk_createdBy foreign KEY ("createdBy") references studio."user" (id),
    constraint fk_updatedBy foreign KEY ("updatedBy") references studio."user" (id)
  ) TABLESPACE pg_default;

  create table studio.role (
    id uuid not null default extensions.uuid_generate_v4 (),
    "organizationId" uuid null,
    name character varying(100) not null,
    description text null,
    permissions text not null,
    "createdDate" timestamp without time zone not null default now(),
    "updatedDate" timestamp without time zone not null default now(),
    "createdBy" uuid null,
    "updatedBy" uuid null,
    constraint role_pkey primary key (id),
    constraint fk_organizationId foreign KEY ("organizationId") references studio.organization (id),
    constraint fk_createdBy foreign KEY ("createdBy") references studio."user" (id),
    constraint fk_updatedBy foreign KEY ("updatedBy") references studio."user" (id)
  ) TABLESPACE pg_default;

  -- 5. Workspace
  CREATE  TABLE studio.workspace (
    id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    name character varying(100) NOT NULL,
    description text NULL,
    "createdDate" timestamp without time zone NOT NULL DEFAULT now(),
    "updatedDate" timestamp without time zone NOT NULL DEFAULT now(),
    "organizationId" uuid NOT NULL,
    "createdBy" uuid NOT NULL,
    "updatedBy" uuid NOT NULL,
    CONSTRAINT "PK_98719043dd804f55-9830ab99f8" PRIMARY KEY (id),
    CONSTRAINT "fk_createdBy" FOREIGN KEY ("createdBy") REFERENCES studio."user"(id),
    CONSTRAINT "fk_updatedBy" FOREIGN KEY ("updatedBy") REFERENCES studio."user"(id),
    CONSTRAINT "fk_organizationId" FOREIGN KEY ("organizationId") REFERENCES studio.organization(id)
  ) TABLESPACE pg_default;

  -- 6. Tablas que dependen de workspace
  CREATE  TABLE studio.apikey (
    id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "apiKey" character varying NOT NULL,
    "apiSecret" character varying NOT NULL,
    "keyName" character varying NOT NULL,
    "updatedDate" timestamp without time zone NOT NULL DEFAULT now(),
    "workspaceId" uuid NULL,
    permissions jsonb NOT NULL DEFAULT '[]'::jsonb,
    CONSTRAINT "PK_96109043dd704f53-9830ab78f0" PRIMARY KEY (id),
    CONSTRAINT fk_apikey_workspaceId FOREIGN KEY ("workspaceId") REFERENCES studio.workspace(id)
  ) TABLESPACE pg_default;
  CREATE INDEX IF NOT EXISTS "idx_apikey_workspaceId" ON studio.apikey USING btree ("workspaceId") TABLESPACE pg_default;

  create table studio.assistant (
    id uuid not null default extensions.uuid_generate_v4 (),
    credential uuid not null,
    details text not null,
    "iconSrc" character varying null,
    "createdDate" timestamp without time zone not null default now(),
    "updatedDate" timestamp without time zone not null default now(),
    "workspaceId" uuid null,
    type text null,
    constraint "PK_3c7cea7a044ac4c92764576cdbf" primary key (id),
    constraint fk_assistant_workspaceId foreign KEY ("workspaceId") references studio.workspace (id)
  ) TABLESPACE pg_default;
  create index IF not exists "idx_assistant_workspaceId" on studio.assistant using btree ("workspaceId") TABLESPACE pg_default;

  create table studio.chat_flow (
    id uuid not null default extensions.uuid_generate_v4 (),
    name character varying not null,
    "flowData" text not null,
    deployed boolean null,
    "isPublic" boolean null,
    apikeyid character varying null,
    "chatbotConfig" text null,
    "createdDate" timestamp without time zone not null default now(),
    "updatedDate" timestamp without time zone not null default now(),
    "apiConfig" text null,
    analytic text null,
    category text null,
    "speechToText" text null,
    type character varying(20) not null default 'CHATFLOW'::text,
    "workspaceId" uuid null,
    "followUpPrompts" text null,
    "textToSpeech" text null,
    "mcpServerConfig" text null,
    constraint "PK_3c7cea7d047ac4b91764574cdbf" primary key (id),
    constraint fk_chat_flow_workspaceId foreign KEY ("workspaceId") references studio.workspace (id)
  ) TABLESPACE pg_default;
  create index IF not exists "idx_chat_flow_workspaceId" on studio.chat_flow using btree ("workspaceId") TABLESPACE pg_default;
  create index IF not exists "IDX_chatflow_name" on studio.chat_flow using btree (
    SUBSTRING(
      name
      from
        1 for 255
    )
  ) TABLESPACE pg_default;

  create table studio.credential (
    id uuid not null default extensions.uuid_generate_v4 (),
    name character varying not null,
    "credentialName" character varying not null,
    "encryptedData" text not null,
    "createdDate" timestamp without time zone not null default now(),
    "updatedDate" timestamp without time zone not null default now(),
    "workspaceId" uuid null,
    constraint "PK_3a5169bcd3d5463cefeec78be82" primary key (id),
    constraint fk_credential_workspaceId foreign KEY ("workspaceId") references studio.workspace (id)
  ) TABLESPACE pg_default;
  create index IF not exists "idx_credential_workspaceId" on studio.credential using btree ("workspaceId") TABLESPACE pg_default;

  create table studio.custom_template (
    id uuid not null default extensions.uuid_generate_v4 (),
    name character varying not null,
    "flowData" text not null,
    description character varying null,
    badge character varying null,
    framework character varying null,
    usecases character varying null,
    type character varying null,
    "createdDate" timestamp without time zone not null default now(),
    "updatedDate" timestamp without time zone not null default now(),
    "workspaceId" uuid null,
    constraint "PK_3c7cea7d087ac4b91764574cdbf" primary key (id),
    constraint fk_custom_template_workspaceId foreign KEY ("workspaceId") references studio.workspace (id)
  ) TABLESPACE pg_default;
  create index IF not exists "idx_custom_template_workspaceId" on studio.custom_template using btree ("workspaceId") TABLESPACE pg_default;

  CREATE  TABLE studio.dataset (
    id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    name character varying NOT NULL,
    description character varying NULL,
    "createdDate" timestamp without time zone NOT NULL DEFAULT now(),
    "updatedDate" timestamp without time zone NOT NULL DEFAULT now(),
    "workspaceId" uuid NULL,
    CONSTRAINT "PK_98419043dd804f54-9830ab99f8" PRIMARY KEY (id),
    CONSTRAINT fk_dataset_workspaceId FOREIGN KEY ("workspaceId") REFERENCES studio.workspace(id)
  ) TABLESPACE pg_default;
  CREATE INDEX IF NOT EXISTS "idx_dataset_workspaceId" ON studio.dataset USING btree ("workspaceId") TABLESPACE pg_default;

  CREATE  TABLE studio.document_store (
    id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    name character varying NOT NULL,
    description character varying NULL,
    loaders text NULL,
    "whereUsed" text NULL,
    status character varying NOT NULL,
    "createdDate" timestamp without time zone NOT NULL DEFAULT now(),
    "updatedDate" timestamp without time zone NOT NULL DEFAULT now(),
    "vectorStoreConfig" text NULL,
    "embeddingConfig" text NULL,
    "recordManagerConfig" text NULL,
    "workspaceId" uuid NULL,
    CONSTRAINT "PK_98495043dd774f54-9830ab78f9" PRIMARY KEY (id),
    CONSTRAINT fk_document_store_workspaceId FOREIGN KEY ("workspaceId") REFERENCES studio.workspace(id)
  ) TABLESPACE pg_default;
  CREATE INDEX IF NOT EXISTS "idx_document_store_workspaceId" ON studio.document_store USING btree ("workspaceId") TABLESPACE pg_default;

  CREATE  TABLE studio.evaluation (
    id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    name character varying NOT NULL,
    "chatflowId" text NOT NULL,
    "chatflowName" text NOT NULL,
    "datasetId" character varying NOT NULL,
    "datasetName" character varying NOT NULL,
    "additionalConfig" text NULL,
    "evaluationType" character varying NOT NULL,
    status character varying NOT NULL,
    average_metrics text NULL,
    "runDate" timestamp without time zone NOT NULL DEFAULT now(),
    "workspaceId" uuid NULL,
    CONSTRAINT "PK_98989043dd804f54-9830ab99f8" PRIMARY KEY (id),
    CONSTRAINT fk_evaluation_workspaceId FOREIGN KEY ("workspaceId") REFERENCES studio.workspace(id)
  ) TABLESPACE pg_default;
  CREATE INDEX IF NOT EXISTS "idx_evaluation_workspaceId" ON studio.evaluation USING btree ("workspaceId") TABLESPACE pg_default;

  CREATE  TABLE studio.evaluator (
    id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    name character varying NOT NULL,
    type text NULL,
    config text NULL,
    "createdDate" timestamp without time zone NOT NULL DEFAULT now(),
    "updatedDate" timestamp without time zone NOT NULL DEFAULT now(),
    "workspaceId" uuid NULL,
    CONSTRAINT "PK_90019043dd804f54-9830ab11f8" PRIMARY KEY (id),
    CONSTRAINT fk_evaluator_workspaceId FOREIGN KEY ("workspaceId") REFERENCES studio.workspace(id)
  ) TABLESPACE pg_default;
  CREATE INDEX IF NOT EXISTS "idx_evaluator_workspaceId" ON studio.evaluator USING btree ("workspaceId") TABLESPACE pg_default;

  create table studio.execution (
    id uuid not null default extensions.uuid_generate_v4 (),
    "executionData" text not null,
    action text null,
    state character varying not null,
    "agentflowId" uuid not null,
    "sessionId" character varying not null,
    "isPublic" boolean null,
    "createdDate" timestamp without time zone not null default now(),
    "updatedDate" timestamp without time zone not null default now(),
    "stoppedDate" timestamp without time zone null,
    "workspaceId" uuid null,
    constraint "PK_936a419c3b8044598d72d95da61" primary key (id),
    constraint fk_execution_workspaceId foreign KEY ("workspaceId") references studio.workspace (id)
  ) TABLESPACE pg_default;
  create index IF not exists "idx_execution_workspaceId" on studio.execution using btree ("workspaceId") TABLESPACE pg_default;

  create table studio.tool (
    id uuid not null default extensions.uuid_generate_v4 (),
    name character varying not null,
    description text not null,
    color character varying not null,
    "iconSrc" character varying null,
    schema text null,
    func text null,
    "createdDate" timestamp without time zone not null default now(),
    "updatedDate" timestamp without time zone not null default now(),
    "workspaceId" uuid null,
    constraint "PK_3bf5b1016a384916073184f99b7" primary key (id),
    constraint fk_tool_workspaceId foreign KEY ("workspaceId") references studio.workspace (id)
  ) TABLESPACE pg_default;
  create index IF not exists "idx_tool_workspaceId" on studio.tool using btree ("workspaceId") TABLESPACE pg_default;

  CREATE  TABLE studio.variable (
    id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    name character varying NOT NULL,
    value text NOT NULL,
    type text NULL,
    "createdDate" timestamp without time zone NOT NULL DEFAULT now(),
    "updatedDate" timestamp without time zone NOT NULL DEFAULT now(),
    "workspaceId" uuid NULL,
    CONSTRAINT "PK_98419043dd704f54-9830ab78f8" PRIMARY KEY (id),
    CONSTRAINT fk_variable_workspaceId FOREIGN KEY ("workspaceId") REFERENCES studio.workspace(id)
  ) TABLESPACE pg_default;
  CREATE INDEX IF NOT EXISTS "idx_variable_workspaceId" ON studio.variable USING btree ("workspaceId") TABLESPACE pg_default;

  CREATE  TABLE studio.workspace_shared (
    id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "workspaceId" uuid NOT NULL,
    "sharedItemId" character varying NOT NULL,
    "itemType" character varying NOT NULL,
    "createdDate" timestamp without time zone NOT NULL DEFAULT now(),
    "updatedDate" timestamp without time zone NOT NULL DEFAULT now(),
    CONSTRAINT "PK_90016043dd804f55-9830ab97f8" PRIMARY KEY (id),
    CONSTRAINT fk_workspace_shared_workspaceId FOREIGN KEY ("workspaceId") REFERENCES studio.workspace(id)
  ) TABLESPACE pg_default;
  CREATE INDEX IF NOT EXISTS "idx_workspace_shared_workspaceId" ON studio.workspace_shared USING btree ("workspaceId") TABLESPACE pg_default;

  -- 7. Tablas pivote / membership
  create table studio.organization_user (
    "organizationId" uuid not null,
    "userId" uuid not null,
    "roleId" uuid not null,
    status character varying(20) not null default 'active'::character varying,
    "createdDate" timestamp without time zone not null default now(),
    "updatedDate" timestamp without time zone not null default now(),
    "createdBy" uuid not null,
    "updatedBy" uuid not null,
    constraint pk_organization_user primary key ("organizationId", "userId"),
    constraint fk_organizationId foreign KEY ("organizationId") references studio.organization (id),
    constraint fk_userId foreign KEY ("userId") references studio."user" (id),
    constraint fk_roleId foreign KEY ("roleId") references studio.role (id),
    constraint fk_createdBy foreign KEY ("createdBy") references studio."user" (id),
    constraint fk_updatedBy foreign KEY ("updatedBy") references studio."user" (id)
  ) TABLESPACE pg_default;

  create table studio.workspace_user (
    "workspaceId" uuid not null,
    "userId" uuid not null,
    "roleId" uuid not null,
    status character varying(20) not null default 'invited'::character varying,
    "lastLogin" timestamp without time zone null,
    "createdDate" timestamp without time zone not null default now(),
    "updatedDate" timestamp without time zone not null default now(),
    "createdBy" uuid not null,
    "updatedBy" uuid not null,
    constraint pk_workspace_user primary key ("workspaceId", "userId"),
    constraint fk_workspaceId foreign KEY ("workspaceId") references studio.workspace (id),
    constraint fk_userId foreign KEY ("userId") references studio."user" (id),
    constraint fk_roleId foreign KEY ("roleId") references studio.role (id),
    constraint fk_createdBy foreign KEY ("createdBy") references studio."user" (id),
    constraint fk_updatedBy foreign KEY ("updatedBy") references studio."user" (id)
  ) TABLESPACE pg_default;

  create table "public"."login_sessions" (
    sid character varying not null,
    sess json not null,
    expire timestamp without time zone not null,
    constraint session_pkey primary key (sid)
  ) TABLESPACE pg_default;
  create index IF not exists "IDX_session_expire" on public.login_sessions using btree (expire) TABLESPACE pg_default;

  alter table "public"."login_sessions" enable row level security;
  CREATE POLICY "Enable all access for all users" ON "public"."login_sessions" TO "studio", "postgres", "authenticated", "service_role" USING (true) WITH CHECK (true);

RESET ROLE;

-- =========================================================
-- WEBUI
-- =========================================================
SET ROLE webui;

  create table webui.alembic_version (
    version_num character varying(32) not null,
    constraint alembic_version_pkc primary key (version_num)
  ) TABLESPACE pg_default;

  create table webui.auth (
    id character varying(255) not null,
    email character varying(255) not null,
    password text not null,
    active boolean not null
  ) TABLESPACE pg_default;
  create unique INDEX IF not exists auth_id on webui.auth using btree (id) TABLESPACE pg_default;

  create table webui.user (
    id character varying(255) not null,
    name character varying(255) not null,
    email character varying(255) not null,
    role character varying(255) not null,
    profile_image_url text not null,
    api_key character varying(255) null,
    created_at bigint not null,
    updated_at bigint not null,
    last_active_at bigint not null,
    settings text null,
    info text null,
    oauth_sub text null,
    username character varying(50) null,
    bio text null,
    gender text null,
    date_of_birth date null
  ) TABLESPACE pg_default;
  create unique INDEX IF not exists user_id on webui."user" using btree (id) TABLESPACE pg_default;
  create unique INDEX IF not exists user_api_key on webui."user" using btree (api_key) TABLESPACE pg_default;
  create unique INDEX IF not exists user_oauth_sub on webui."user" using btree (oauth_sub) TABLESPACE pg_default;

  create table webui.channel (
    id text not null,
    user_id text null,
    name text null,
    description text null,
    data json null,
    meta json null,
    access_control json null,
    created_at bigint null,
    updated_at bigint null,
    type text null,
    constraint channel_pkey primary key (id)
  ) TABLESPACE pg_default;

  create table webui.channel_member (
    id text not null,
    channel_id text not null,
    user_id text not null,
    created_at bigint null,
    constraint channel_member_pkey primary key (id)
  ) TABLESPACE pg_default;

  create table webui.chat (
    id character varying(255) not null,
    user_id character varying(255) not null,
    title text not null,
    share_id character varying(255) null,
    archived boolean not null,
    created_at bigint not null,
    updated_at bigint not null,
    chat json null,
    pinned boolean null,
    meta json not null default '{}'::json,
    folder_id text null
  ) TABLESPACE pg_default;
  create unique INDEX IF not exists chat_id on webui.chat using btree (id) TABLESPACE pg_default;
  create unique INDEX IF not exists chat_share_id on webui.chat using btree (share_id) TABLESPACE pg_default;
  create index IF not exists folder_id_idx on webui.chat using btree (folder_id) TABLESPACE pg_default;
  create index IF not exists user_id_pinned_idx on webui.chat using btree (user_id, pinned) TABLESPACE pg_default;
  create index IF not exists user_id_archived_idx on webui.chat using btree (user_id, archived) TABLESPACE pg_default;
  create index IF not exists updated_at_user_id_idx on webui.chat using btree (updated_at, user_id) TABLESPACE pg_default;
  create index IF not exists folder_id_user_id_idx on webui.chat using btree (folder_id, user_id) TABLESPACE pg_default;

  create table webui.chatidtag (
    id character varying(255) not null,
    tag_name character varying(255) not null,
    chat_id character varying(255) not null,
    user_id character varying(255) not null,
    timestamp bigint not null
  ) TABLESPACE pg_default;
  create unique INDEX IF not exists chatidtag_id on webui.chatidtag using btree (id) TABLESPACE pg_default;

  create table webui.config (
    id serial not null,
    data json not null,
    version integer not null,
    created_at timestamp without time zone not null default now(),
    updated_at timestamp without time zone null default now(),
    constraint config_pkey primary key (id)
  ) TABLESPACE pg_default;

  create table webui.document (
    id serial not null,
    collection_name character varying(255) not null,
    name character varying(255) not null,
    title text not null,
    filename text not null,
    content text null,
    user_id character varying(255) not null,
    timestamp bigint not null,
    constraint document_pkey primary key (id)
  ) TABLESPACE pg_default;
  create unique INDEX IF not exists document_collection_name on webui.document using btree (collection_name) TABLESPACE pg_default;
  create unique INDEX IF not exists document_name on webui.document using btree (name) TABLESPACE pg_default;

  create table webui.feedback (
    id text not null,
    user_id text null,
    version bigint null,
    type text null,
    data json null,
    meta json null,
    snapshot json null,
    created_at bigint not null,
    updated_at bigint not null,
    constraint feedback_pkey primary key (id)
  ) TABLESPACE pg_default;

  create table webui.file (
    id text not null,
    user_id text not null,
    filename text not null,
    meta json null,
    created_at bigint not null,
    hash text null,
    data json null,
    updated_at bigint null,
    path text null,
    access_control json null
  ) TABLESPACE pg_default;
  create unique INDEX IF not exists file_id on webui.file using btree (id) TABLESPACE pg_default;

  create table webui.folder (
    id text not null,
    parent_id text null,
    user_id text not null,
    name text not null,
    items json null,
    meta json null,
    is_expanded boolean not null,
    created_at bigint not null,
    updated_at bigint not null,
    data json null,
    constraint folder_pkey primary key (id, user_id)
  ) TABLESPACE pg_default;

  create table webui.function (
    id text not null,
    user_id text not null,
    name text not null,
    type text not null,
    content text not null,
    meta text not null,
    created_at bigint not null,
    updated_at bigint not null,
    valves text null,
    is_active boolean not null,
    is_global boolean not null
  ) TABLESPACE pg_default;
  create unique INDEX IF not exists function_id on webui.function using btree (id) TABLESPACE pg_default;
  create index IF not exists is_global_idx on webui.function using btree (is_global) TABLESPACE pg_default;

  create table webui.group (
    id text not null,
    user_id text null,
    name text null,
    description text null,
    data json null,
    meta json null,
    permissions json null,
    user_ids json null,
    created_at bigint null,
    updated_at bigint null,
    constraint group_pkey primary key (id)
  ) TABLESPACE pg_default;

  create table webui.knowledge (
    id text not null,
    user_id text not null,
    name text not null,
    description text null,
    data json null,
    meta json null,
    created_at bigint not null,
    updated_at bigint null,
    access_control json null,
    constraint knowledge_pkey primary key (id)
  ) TABLESPACE pg_default;

  create table webui.memory (
    id character varying(255) not null,
    user_id character varying(255) not null,
    content text not null,
    updated_at bigint not null,
    created_at bigint not null
  ) TABLESPACE pg_default;
  create unique INDEX IF not exists memory_id on webui.memory using btree (id) TABLESPACE pg_default;

  create table webui.message (
    id text not null,
    user_id text null,
    channel_id text null,
    content text null,
    data json null,
    meta json null,
    created_at bigint null,
    updated_at bigint null,
    parent_id text null,
    constraint message_pkey primary key (id)
  ) TABLESPACE pg_default;

  create table webui.message_reaction (
    id text not null,
    user_id text not null,
    message_id text not null,
    name text not null,
    created_at bigint null,
    constraint message_reaction_pkey primary key (id)
  ) TABLESPACE pg_default;

  create table webui.migratehistory (
    id serial not null,
    name character varying(255) not null,
    migrated_at timestamp without time zone not null,
    constraint migratehistory_pkey primary key (id)
  ) TABLESPACE pg_default;

  create table webui.model (
    id text not null,
    user_id text not null,
    base_model_id text null,
    name text not null,
    meta text not null,
    params text not null,
    created_at bigint not null,
    updated_at bigint not null,
    access_control json null,
    is_active boolean not null default true
  ) TABLESPACE pg_default;
  create unique INDEX IF not exists model_id on webui.model using btree (id) TABLESPACE pg_default;

  create table webui.note (
    id text not null,
    user_id text null,
    title text null,
    data json null,
    meta json null,
    access_control json null,
    created_at bigint null,
    updated_at bigint null,
    constraint note_pkey primary key (id)
  ) TABLESPACE pg_default;

  create table webui.oauth_session (
    id text not null,
    user_id text not null,
    provider text not null,
    token text not null,
    expires_at bigint not null,
    created_at bigint not null,
    updated_at bigint not null,
    constraint oauth_session_pkey primary key (id),
    constraint oauth_session_user_id_fkey foreign KEY (user_id) references webui."user" (id) on delete CASCADE
  ) TABLESPACE pg_default;
  create index IF not exists idx_oauth_session_user_id on webui.oauth_session using btree (user_id) TABLESPACE pg_default;
  create index IF not exists idx_oauth_session_expires_at on webui.oauth_session using btree (expires_at) TABLESPACE pg_default;
  create index IF not exists idx_oauth_session_user_provider on webui.oauth_session using btree (user_id, provider) TABLESPACE pg_default;

  create table webui.prompt (
    id serial not null,
    command character varying(255) not null,
    user_id character varying(255) not null,
    title text not null,
    content text not null,
    timestamp bigint not null,
    access_control json null,
    constraint prompt_pkey primary key (id)
  ) TABLESPACE pg_default;
  create unique INDEX IF not exists prompt_command on webui.prompt using btree (command) TABLESPACE pg_default;

  create table webui.tag (
    id character varying(255) not null,
    name character varying(255) not null,
    user_id character varying(255) not null,
    meta json null,
    constraint pk_id_user_id primary key (id, user_id)
  ) TABLESPACE pg_default;
  create index IF not exists user_id_idx on webui.tag using btree (user_id) TABLESPACE pg_default;

  create table webui.tool (
    id text not null,
    user_id text not null,
    name text not null,
    content text not null,
    specs text not null,
    meta text not null,
    created_at bigint not null,
    updated_at bigint not null,
    valves text null,
    access_control json null
  ) TABLESPACE pg_default;
  create unique INDEX IF not exists tool_id on webui.tool using btree (id) TABLESPACE pg_default;

RESET ROLE;
