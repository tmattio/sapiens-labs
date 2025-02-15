CREATE TYPE "dataset_source_format" AS ENUM (
  'CSV',
  'OTHER'
);

CREATE TABLE "public"."dataset_sources"(
  "id" serial NOT NULL,
  "dataset_id" int NOT NULL,
  "format" "dataset_source_format" NOT NULL,
  "url" text UNIQUE CONSTRAINT "url_length" CHECK (char_length("url") <= 2000),
  "created_at" timestamp(0) without time zone NOT NULL DEFAULT now(),
  PRIMARY KEY ("id"),
  CONSTRAINT "dataset_sources_dataset_id_fkey" FOREIGN KEY ("dataset_id")
    REFERENCES "public"."datasets" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE UNIQUE INDEX "dataset_sources_dataset_id_url_index"
  ON "public"."dataset_sources" USING btree
  ("dataset_id", "url");
