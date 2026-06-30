SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict 1qEkIwsSCFncsmeMSFbYJmRO5AibvbRNTAeCpWGxHihOYSOomY1UvOaFWusixcm

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
-- Data for Name: user; Type: TABLE DATA; Schema: studio; Owner: studio
--

INSERT INTO "studio"."user" ("id", "name", "email", "credential", "tempToken", "tokenExpiry", "status", "createdDate", "updatedDate", "createdBy", "updatedBy") VALUES
	('c5c27317-4fb8-4e0c-be6b-ae9fd6808913', 'cloud', 'cloud@seidoranalytics.com', '$2a$10$9Xft5P9vN7dB.Q/Z5Nb3FOqMxNJwHl6uM/WMcZ9MF5nmugmwvw4he', NULL, NULL, 'active', '2026-06-26 01:23:46.277767', '2026-06-26 01:23:46.277767', 'c5c27317-4fb8-4e0c-be6b-ae9fd6808913', 'c5c27317-4fb8-4e0c-be6b-ae9fd6808913');


--
-- Data for Name: organization; Type: TABLE DATA; Schema: studio; Owner: studio
--

INSERT INTO "studio"."organization" ("id", "name", "customerId", "subscriptionId", "createdDate", "updatedDate", "createdBy", "updatedBy") VALUES
	('ca2a7ece-14c6-458c-9266-5c3d96e547f2', 'Default Organization', NULL, NULL, '2026-06-26 01:23:46.277767', '2026-06-26 01:23:46.277767', 'c5c27317-4fb8-4e0c-be6b-ae9fd6808913', 'c5c27317-4fb8-4e0c-be6b-ae9fd6808913');


--
-- Data for Name: workspace; Type: TABLE DATA; Schema: studio; Owner: studio
--

INSERT INTO "studio"."workspace" ("id", "name", "description", "createdDate", "updatedDate", "organizationId", "createdBy", "updatedBy") VALUES
	('cd469aed-4042-477b-b508-9de39d395056', 'Default Workspace', NULL, '2026-06-26 01:23:46.277767', '2026-06-26 01:23:46.277767', 'ca2a7ece-14c6-458c-9266-5c3d96e547f2', 'c5c27317-4fb8-4e0c-be6b-ae9fd6808913', 'c5c27317-4fb8-4e0c-be6b-ae9fd6808913');


--
-- Data for Name: apikey; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: assistant; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: chat_flow; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: chat_message; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: chat_message_feedback; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: credential; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: custom_mcp_server; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: custom_template; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: dataset; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: dataset_row; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: document_store; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: document_store_file_chunk; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: evaluation; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: evaluation_run; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: evaluator; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: execution; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: lead; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: login_activity; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: login_method; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: migrations; Type: TABLE DATA; Schema: studio; Owner: studio
--

INSERT INTO "studio"."migrations" ("id", "timestamp", "name") VALUES
	(1, 1693891895163, 'Init1693891895163'),
	(2, 1693995626941, 'ModifyChatFlow1693995626941'),
	(3, 1693996694528, 'ModifyChatMessage1693996694528'),
	(4, 1693997070000, 'ModifyCredential1693997070000'),
	(5, 1693997339912, 'ModifyTool1693997339912'),
	(6, 1694099183389, 'AddApiConfig1694099183389'),
	(7, 1694432361423, 'AddAnalytic1694432361423'),
	(8, 1694658756136, 'AddChatHistory1694658756136'),
	(9, 1699325775451, 'AddAssistantEntity1699325775451'),
	(10, 1699325775451, 'AddVariableEntity1699325775451'),
	(11, 1699481607341, 'AddUsedToolsToChatMessage1699481607341'),
	(12, 1699900910291, 'AddCategoryToChatFlow1699900910291'),
	(13, 1700271021237, 'AddFileAnnotationsToChatMessage1700271021237'),
	(14, 1701788586491, 'AddFileUploadsToChatMessage1701788586491'),
	(15, 1706364937060, 'AddSpeechToText1706364937060'),
	(16, 1707213601923, 'AddFeedback1707213601923'),
	(17, 1709814301358, 'AddUpsertHistoryEntity1709814301358'),
	(18, 1710497452584, 'FieldTypes1710497452584'),
	(19, 1710832137905, 'AddLead1710832137905'),
	(20, 1711538016098, 'AddLeadToChatMessage1711538016098'),
	(21, 1711637331047, 'AddDocumentStore1711637331047'),
	(22, 1714548873039, 'AddEvaluation1714548873039'),
	(23, 1714548903384, 'AddDatasets1714548903384'),
	(24, 1714679514451, 'AddAgentReasoningToChatMessage1714679514451'),
	(25, 1714808591644, 'AddEvaluator1714808591644'),
	(26, 1715861032479, 'AddVectorStoreConfigToDocStore1715861032479'),
	(27, 1716300000000, 'AddTypeToChatFlow1716300000000'),
	(28, 1720230151480, 'AddApiKey1720230151480'),
	(29, 1720230151482, 'AddAuthTables1720230151482'),
	(30, 1720230151484, 'AddWorkspace1720230151484'),
	(31, 1721078251523, 'AddActionToChatMessage1721078251523'),
	(32, 1725629836652, 'AddCustomTemplate1725629836652'),
	(33, 1726156258465, 'AddArtifactsToChatMessage1726156258465'),
	(34, 1726654922034, 'AddWorkspaceShared1726654922034'),
	(35, 1726655750383, 'AddWorkspaceIdToCustomTemplate1726655750383'),
	(36, 1726666309552, 'AddFollowUpPrompts1726666309552'),
	(37, 1727798417345, 'AddOrganization1727798417345'),
	(38, 1729130948686, 'LinkWorkspaceId1729130948686'),
	(39, 1729133111652, 'LinkOrganizationId1729133111652'),
	(40, 1730519457880, 'AddSSOColumns1730519457880'),
	(41, 1733011290987, 'AddTypeToAssistant1733011290987'),
	(42, 1733752119696, 'AddSeqNoToDatasetRow1733752119696'),
	(43, 1734074497540, 'AddPersonalWorkspace1734074497540'),
	(44, 1737076223692, 'RefactorEnterpriseDatabase1737076223692'),
	(45, 1738090872625, 'AddExecutionEntity1738090872625'),
	(46, 1743758056188, 'FixOpenSourceAssistantTable1743758056188'),
	(47, 1744964560174, 'AddErrorToEvaluationRun1744964560174'),
	(48, 1746862866554, 'ExecutionLinkWorkspaceId1746862866554'),
	(49, 1748450230238, 'ModifyExecutionSessionIdFieldType1748450230238'),
	(50, 1754986480347, 'AddTextToSpeechToChatFlow1754986480347'),
	(51, 1755066758601, 'ModifyChatflowType1755066758601'),
	(52, 1759419194331, 'AddTextToSpeechToChatFlow1759419194331'),
	(53, 1759424903973, 'AddChatFlowNameIndex1759424903973'),
	(54, 1764759496768, 'AddReasonContentToChatMessage1764759496768'),
	(55, 1765360298674, 'AddApiKeyPermission1765360298674'),
	(56, 1766000000000, 'AddCustomMcpServer1766000000000'),
	(57, 1767000000000, 'AddMcpServerConfigToChatFlow1767000000000');


--
-- Data for Name: role; Type: TABLE DATA; Schema: studio; Owner: studio
--

INSERT INTO "studio"."role" ("id", "organizationId", "name", "description", "permissions", "createdDate", "updatedDate", "createdBy", "updatedBy") VALUES
	('d361500f-42c8-44ef-93e6-a26d3ebeb72e', NULL, 'owner', 'Has full control over the organization.', '["organization","workspace"]', '2026-06-26 01:19:44.661933', '2026-06-26 01:19:44.661933', NULL, NULL),
	('cd4f69b6-1b2c-4c3f-a47c-7ceaf67bacdd', NULL, 'member', 'Has limited control over the organization.', '[]', '2026-06-26 01:19:44.661933', '2026-06-26 01:19:44.661933', NULL, NULL),
	('e558f14f-ab9f-43b1-9ef8-0b76c57d5254', NULL, 'personal workspace', 'Has full control over the personal workspace', '["chatflows:view","chatflows:create","chatflows:update","chatflows:duplicate","chatflows:delete","chatflows:export","chatflows:import","chatflows:config","chatflows:domains","agentflows:view","agentflows:create","agentflows:update","agentflows:duplicate","agentflows:delete","agentflows:export","agentflows:import","agentflows:config","agentflows:domains","tools:view","tools:create","tools:update","tools:delete","tools:export","assistants:view","assistants:create","assistants:update","assistants:delete","credentials:view","credentials:create","credentials:update","credentials:delete","credentials:share","variables:view","variables:create","variables:update","variables:delete","apikeys:view","apikeys:create","apikeys:update","apikeys:delete","documentStores:view","documentStores:create","documentStores:update","documentStores:delete","documentStores:add-loader","documentStores:delete-loader","documentStores:preview-process","documentStores:upsert-config","datasets:view","datasets:create","datasets:update","datasets:delete","evaluators:view","evaluators:create","evaluators:update","evaluators:delete","evaluations:view","evaluations:create","evaluations:update","evaluations:delete","evaluations:run","templates:marketplace","templates:custom","templates:custom-delete","templates:toolexport","templates:flowexport","templates:custom-share","workspace:export","workspace:import","executions:view","executions:delete"]', '2026-06-26 01:19:44.661933', '2026-06-26 01:19:44.661933', NULL, NULL);


--
-- Data for Name: organization_user; Type: TABLE DATA; Schema: studio; Owner: studio
--

INSERT INTO "studio"."organization_user" ("organizationId", "userId", "roleId", "status", "createdDate", "updatedDate", "createdBy", "updatedBy") VALUES
	('ca2a7ece-14c6-458c-9266-5c3d96e547f2', 'c5c27317-4fb8-4e0c-be6b-ae9fd6808913', 'd361500f-42c8-44ef-93e6-a26d3ebeb72e', 'active', '2026-06-26 01:23:46.277767', '2026-06-26 01:23:46.277767', 'c5c27317-4fb8-4e0c-be6b-ae9fd6808913', 'c5c27317-4fb8-4e0c-be6b-ae9fd6808913');


--
-- Data for Name: tool; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: upsert_history; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: variable; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: workspace_shared; Type: TABLE DATA; Schema: studio; Owner: studio
--



--
-- Data for Name: workspace_user; Type: TABLE DATA; Schema: studio; Owner: studio
--

INSERT INTO "studio"."workspace_user" ("workspaceId", "userId", "roleId", "status", "lastLogin", "createdDate", "updatedDate", "createdBy", "updatedBy") VALUES
	('cd469aed-4042-477b-b508-9de39d395056', 'c5c27317-4fb8-4e0c-be6b-ae9fd6808913', 'd361500f-42c8-44ef-93e6-a26d3ebeb72e', 'active', NULL, '2026-06-26 01:23:46.277767', '2026-06-26 01:23:46.277767', 'c5c27317-4fb8-4e0c-be6b-ae9fd6808913', 'c5c27317-4fb8-4e0c-be6b-ae9fd6808913');


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: studio; Owner: studio
--

SELECT pg_catalog.setval('"studio"."migrations_id_seq"', 57, true);


--
-- PostgreSQL database dump complete
--

-- \unrestrict 1qEkIwsSCFncsmeMSFbYJmRO5AibvbRNTAeCpWGxHihOYSOomY1UvOaFWusixcm

RESET ALL;
