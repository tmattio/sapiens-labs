CREATE TABLE "public"."dataset_datapoints"(
  "id" serial NOT NULL,
  "dataset_id" int NOT NULL,
  "split" text,
  "created_at" timestamp(0) without time zone NOT NULL DEFAULT now(),
  PRIMARY KEY ("id"),
  CONSTRAINT "dataset_datapoints_dataset_id_fkey" FOREIGN KEY ("dataset_id")
    REFERENCES "public"."datasets" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE INDEX "dataset_datapoints_created_at_index"
  ON "public"."dataset_datapoints" USING btree
  ("created_at");

CREATE TABLE "public"."dataset_feature_definitions"(
  "id" serial NOT NULL,
  "dataset_id" int NOT NULL,
  "feature_name" text NOT NULL CONSTRAINT "feature_name_length" CHECK (char_length("feature_name") <= 60),
  "feature_type" text NOT NULL CONSTRAINT "feature_type" CHECK (char_length("feature_type") <= 60),
  "definition" json NOT NULL,

  PRIMARY KEY ("id"),
  CONSTRAINT "dataset_feature_definitions_dataset_id_fkey" FOREIGN KEY ("dataset_id")
    REFERENCES "public"."datasets" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE UNIQUE INDEX "dataset_feature_definitions_dataset_id_feature_name_index"
  ON "public"."dataset_feature_definitions" USING btree
  ("dataset_id", "feature_name");

CREATE TABLE "public"."dataset_datapoint_features"(
  "id" serial NOT NULL,
  "datapoint_id" int NOT NULL,
  "feature_definition_id" int NOT NULL,
  "feature_type" text NOT NULL CONSTRAINT "feature_type" CHECK (char_length("feature_type") <= 60),
  "feature" json NOT NULL,

  PRIMARY KEY ("id"),
  CONSTRAINT "dataset_datapoint_features_feature_definition_id_fkey" FOREIGN KEY ("feature_definition_id")
    REFERENCES "public"."dataset_feature_definitions" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE,
  CONSTRAINT "dataset_datapoint_features_datapoint_id_fkey" FOREIGN KEY ("datapoint_id")
    REFERENCES "public"."dataset_datapoints" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE UNIQUE INDEX "dataset_datapoint_features_datapoint_id_feature_definition_id_index"
  ON "public"."dataset_datapoint_features" USING btree
  ("datapoint_id", "feature_definition_id");

CREATE INDEX "dataset_datapoint_features_feature_definition_id_index"
  ON "public"."dataset_datapoint_features" USING btree
  ("feature_definition_id");
