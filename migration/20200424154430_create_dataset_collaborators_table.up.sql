CREATE TABLE "public"."dataset_collaborators"(
  "id" serial NOT NULL,
  "user_id" int NOT NULL,
  "dataset_id" int NOT NULL,
  "created_at" timestamp(0) without time zone NOT NULL DEFAULT now(),
  PRIMARY KEY ("id"),
  CONSTRAINT "dataset_collaborators_user_id_fkey" FOREIGN KEY ("user_id")
    REFERENCES "public"."users" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE,
  CONSTRAINT "dataset_collaborators_dataset_id_fkey" FOREIGN KEY ("dataset_id")
    REFERENCES "public"."datasets" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE INDEX "dataset_collaborators_dataset_id_index"
  ON "public"."dataset_collaborators" USING btree
  ("dataset_id");

CREATE UNIQUE INDEX "dataset_collaborators_user_id_dataset_id_index"
  ON "public"."dataset_collaborators" USING btree
  ("user_id", "dataset_id");

CREATE TABLE "public"."datasets_tokens"(
  "id" serial NOT NULL,
  "user_id" int NOT NULL,
  "dataset_id" int NOT NULL,
  "token" bytea NOT NULL,
  "context" text NOT NULL,
  "sent_to" email NOT NULL,
  "created_at" timestamp(0) without time zone NOT NULL DEFAULT now(),
  PRIMARY KEY ("id"),
  CONSTRAINT "datasets_tokens_user_id_fkey" FOREIGN KEY ("user_id")
    REFERENCES "public"."users" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE,
  CONSTRAINT "datasets_tokens_dataset_id_fkey" FOREIGN KEY ("dataset_id")
    REFERENCES "public"."datasets" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE UNIQUE INDEX "datasets_tokens_context_token_index"
  ON "public"."datasets_tokens" USING btree
  ("context", "token");

CREATE INDEX "datasets_tokens_user_id_index"
  ON "public"."datasets_tokens" USING btree
  ("user_id");

CREATE INDEX "datasets_tokens_dataset_id_index"
  ON "public"."datasets_tokens" USING btree
  ("dataset_id");
