SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict w9ndQpJlv71FTqACQpk3g44sZK91Plj0bxdgUvbqrl2jtKtShgqjEz3tDCc2Bln

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: webui; Owner: webui
--

INSERT INTO "webui"."alembic_version" ("version_num") VALUES
	('38d63c18f30f');


--
-- Data for Name: auth; Type: TABLE DATA; Schema: webui; Owner: webui
--

INSERT INTO "webui"."auth" ("id", "email", "password", "active") VALUES
	('354611b1-7089-4a0a-bf38-16625e4d9858', 'cloud@seidoranalytics.com', '$2b$12$.HJu/KjH2ucfBdf5/wydQOo7V3wfeMNWL4sA.DYhOCe793adRTReq', true);


--
-- Data for Name: channel; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: channel_member; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: chat; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: chatidtag; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: config; Type: TABLE DATA; Schema: webui; Owner: webui
--

INSERT INTO "webui"."config" ("id", "data", "version", "created_at", "updated_at") VALUES
	(1, '{"version": 0, "ui": {"enable_signup": false}}', 0, '2026-06-26 20:32:52.003485', NULL);


--
-- Data for Name: document; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: feedback; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: file; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: folder; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: function; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: group; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: knowledge; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: memory; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: message; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: message_reaction; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: migratehistory; Type: TABLE DATA; Schema: webui; Owner: webui
--

INSERT INTO "webui"."migratehistory" ("id", "name", "migrated_at") VALUES
	(1, '001_initial_schema', '2026-06-26 01:19:28.660427'),
	(2, '002_add_local_sharing', '2026-06-26 01:19:28.889597'),
	(3, '003_add_auth_api_key', '2026-06-26 01:19:28.937507'),
	(4, '004_add_archived', '2026-06-26 01:19:29.025095'),
	(5, '005_add_updated_at', '2026-06-26 01:19:29.168197'),
	(6, '006_migrate_timestamps_and_charfields', '2026-06-26 01:19:29.238069'),
	(7, '007_add_user_last_active_at', '2026-06-26 01:19:29.386122'),
	(8, '008_add_memory', '2026-06-26 01:19:29.442661'),
	(9, '009_add_models', '2026-06-26 01:19:29.543272'),
	(10, '010_migrate_modelfiles_to_models', '2026-06-26 01:19:29.630991'),
	(11, '011_add_user_settings', '2026-06-26 01:19:29.719551'),
	(12, '012_add_tools', '2026-06-26 01:19:29.818777'),
	(13, '013_add_user_info', '2026-06-26 01:19:29.86222'),
	(14, '014_add_files', '2026-06-26 01:19:29.947355'),
	(15, '015_add_functions', '2026-06-26 01:19:30.008623'),
	(16, '016_add_valves_and_is_active', '2026-06-26 01:19:30.072237'),
	(17, '017_add_user_oauth_sub', '2026-06-26 01:19:30.164399'),
	(18, '018_add_function_is_global', '2026-06-26 01:19:30.220297');


--
-- Data for Name: model; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: note; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: user; Type: TABLE DATA; Schema: webui; Owner: webui
--

INSERT INTO "webui"."user" ("id", "name", "email", "role", "profile_image_url", "api_key", "created_at", "updated_at", "last_active_at", "settings", "info", "oauth_sub", "username", "bio", "gender", "date_of_birth") VALUES
	('354611b1-7089-4a0a-bf38-16625e4d9858', 'Cloud Seidor Analytics', 'cloud@seidoranalytics.com', 'admin', 'data:image/png;base64,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', NULL, 1782505971, 1782505971, 1782506069, '{"ui": {"version": "0.6.30"}}', 'null', NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: oauth_session; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: prompt; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: tag; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Data for Name: tool; Type: TABLE DATA; Schema: webui; Owner: webui
--



--
-- Name: config_id_seq; Type: SEQUENCE SET; Schema: webui; Owner: webui
--

SELECT pg_catalog.setval('"webui"."config_id_seq"', 1, true);


--
-- Name: document_id_seq; Type: SEQUENCE SET; Schema: webui; Owner: webui
--

SELECT pg_catalog.setval('"webui"."document_id_seq"', 1, false);


--
-- Name: migratehistory_id_seq; Type: SEQUENCE SET; Schema: webui; Owner: webui
--

SELECT pg_catalog.setval('"webui"."migratehistory_id_seq"', 18, true);


--
-- Name: prompt_id_seq; Type: SEQUENCE SET; Schema: webui; Owner: webui
--

SELECT pg_catalog.setval('"webui"."prompt_id_seq"', 1, false);


--
-- PostgreSQL database dump complete
--

-- \unrestrict w9ndQpJlv71FTqACQpk3g44sZK91Plj0bxdgUvbqrl2jtKtShgqjEz3tDCc2Bln

RESET ALL;
