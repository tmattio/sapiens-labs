CREATE TYPE "dataset_export_format" AS ENUM (
  'CSV',
  'TFRECORD'
);

CREATE TABLE "public"."dataset_exports"(
  "id" serial NOT NULL,
  "dataset_id" int NOT NULL,
  "format" "dataset_export_format" NOT NULL,
  "url" text UNIQUE CONSTRAINT "url_length" CHECK (char_length("url") <= 2000),
  "created_at" timestamp(0) without time zone NOT NULL DEFAULT now(),
  PRIMARY KEY ("id"),
  CONSTRAINT "dataset_exports_dataset_id_fkey" FOREIGN KEY ("dataset_id")
    REFERENCES "public"."datasets" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE UNIQUE INDEX "dataset_exports_dataset_id_url_index"
  ON "public"."dataset_exports" USING btree
  ("dataset_id", "url");
