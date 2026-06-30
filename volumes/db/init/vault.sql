CREATE OR REPLACE FUNCTION "public"."vault_access"("secret_id" "uuid" DEFAULT NULL::"uuid") RETURNS TABLE("name" "text", "decrypted_secret" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
BEGIN
    IF secret_id IS NOT NULL THEN
        RETURN QUERY
        SELECT
            s.name,
            s.decrypted_secret
        FROM
            vault.decrypted_secrets AS s
        WHERE
            s.id = secret_id;
    ELSE
        RETURN QUERY
        SELECT
            s.name,
            s.decrypted_secret
        FROM
            vault.decrypted_secrets AS s;
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION "public"."vault_upsert_secret"(
    secret_value text,
    secret_name text,
    secret_description text DEFAULT 'This is the description'
) RETURNS uuid
    LANGUAGE plpgsql
    SECURITY DEFINER
    SET search_path TO ''
    AS $$
DECLARE
    existing_id uuid;
    created_id uuid;
BEGIN
    SELECT id
    INTO existing_id
    FROM vault.secrets
    WHERE name = secret_name
    LIMIT 1;

    IF existing_id IS NULL THEN
        SELECT vault.create_secret(secret_value, secret_name, secret_description)
        INTO created_id;
        RETURN created_id;
    END IF;

    PERFORM vault.update_secret(existing_id, secret_value, secret_name, secret_description);
    RETURN existing_id;
END;
$$;

SELECT public.vault_upsert_secret(:'supabase_public_url', 'NEXT_PUBLIC_SUPABASE_URL', 'This is the description');
SELECT public.vault_upsert_secret(:'next_public_api_python', 'NEXT_PUBLIC_API_PYTHON', 'This is the description');
SELECT public.vault_upsert_secret(:'next_public_api_training', 'NEXT_PUBLIC_API_TRAINING', 'This is the description');
SELECT public.vault_upsert_secret(:'next_public_api_qdrant', 'NEXT_PUBLIC_API_QDRANT', 'This is the description');
SELECT public.vault_upsert_secret(:'next_public_api_msteams', 'NEXT_PUBLIC_API_MSTEAMS', 'This is the description');
SELECT public.vault_upsert_secret(:'next_public_api_whatsapp', 'NEXT_PUBLIC_API_WHATSAPP', 'This is the description');
SELECT public.vault_upsert_secret(:'next_public_api_studio_base_url', 'NEXT_PUBLIC_API_STUDIO_BASE_URL', 'This is the description');
SELECT public.vault_upsert_secret(:'next_public_webui_url', 'NEXT_PUBLIC_WEBUI_URL', 'This is the description');
SELECT public.vault_upsert_secret(:'next_public_app_url', 'NEXT_PUBLIC_APP_URL', 'This is the description');
SELECT public.vault_upsert_secret(:'cors_allow_origin', 'CORS_ALLOW_ORIGIN', 'This is the description');
