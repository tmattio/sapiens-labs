CREATE DOMAIN "model_name" AS citext CHECK (
  value ~ '^[a-zA-Z0-9_-]*$'
);

CREATE TABLE "public"."models"(
  "id" serial NOT NULL,
  "user_id" int NOT NULL,
  "name" "model_name" CONSTRAINT "name_length" CHECK (char_length("name") <= 60),
  "description" text UNIQUE CONSTRAINT "description_length" CHECK (char_length("description") <= 120),
  "created_at" timestamp(0) without time zone NOT NULL DEFAULT now(),
  "updated_at" timestamp(0) without time zone NOT NULL DEFAULT now(),
  PRIMARY KEY ("id"),
  CONSTRAINT "models_user_id_fkey" FOREIGN KEY ("user_id")
    REFERENCES "public"."users" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE UNIQUE INDEX "models_user_id_name_index"
  ON "public"."models" USING btree
  ("user_id", "name");

CREATE OR REPLACE FUNCTION "public"."set_current_timestamp_updated_at"()
RETURNS TRIGGER AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = now();
  RETURN _new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER "set_public_models_updated_at"
BEFORE UPDATE ON "public"."models"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();

COMMENT ON TRIGGER "set_public_models_updated_at" ON "public"."models" 
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
