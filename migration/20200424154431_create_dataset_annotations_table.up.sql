CREATE TYPE "annotation_task_state" AS ENUM (
  'IN_PROGRESS',
  'COMPLETED',
  'CANCELED'
);

CREATE TYPE "annotation_task_feature_type" AS ENUM (
  'INPUT',
  'OUTPUT'
);

CREATE TABLE "public"."annotation_tasks"(
  "id" serial NOT NULL,
  "creator_id" int NOT NULL,
  "dataset_id" int NOT NULL,
  "name" text NOT NULL,
  "guidelines_url" text,
  "state" "annotation_task_state" NOT NULL DEFAULT 'IN_PROGRESS',
  "created_at" timestamp(0) without time zone NOT NULL DEFAULT now(),
  PRIMARY KEY ("id"),
  CONSTRAINT "annotation_tasks_creator_id_fkey" FOREIGN KEY ("creator_id")
    REFERENCES "public"."users" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE,
  CONSTRAINT "annotation_tasks_dataset_id_fkey" FOREIGN KEY ("dataset_id")
    REFERENCES "public"."datasets" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE INDEX "annotation_tasks_creator_id_index"
  ON "public"."annotation_tasks" USING btree
  ("creator_id");

CREATE INDEX "annotation_tasks_dataset_id_index"
  ON "public"."annotation_tasks" USING btree
  ("dataset_id");

CREATE TABLE "public"."annotation_task_features"(
  "id" serial NOT NULL,
  "dataset_feature_definition_id" int NOT NULL,
  "annotation_task_id" int NOT NULL,
  "type" "annotation_task_feature_type" NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "dataset_feature_definition_id_fkey" FOREIGN KEY ("dataset_feature_definition_id")
    REFERENCES "public"."dataset_feature_definitions" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE,
  CONSTRAINT "annotation_task_id_fkey" FOREIGN KEY ("annotation_task_id")
    REFERENCES "public"."annotation_tasks" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE UNIQUE INDEX "annotation_task_features_annotation_task_id_dataset_feature_definition_id_index"
  ON "public"."annotation_task_features" USING btree
  ("annotation_task_id", "dataset_feature_definition_id");

CREATE TABLE "public"."annotations"(
  "id" serial NOT NULL,
  "user_id" int NOT NULL,
  "datapoint_id" int NOT NULL,
  "annotation_task_id" int NOT NULL,
  "annotated_at" timestamp(0) without time zone,
  PRIMARY KEY ("id"),
  CONSTRAINT "annotations_user_id_fkey" FOREIGN KEY ("user_id")
    REFERENCES "public"."users" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE,
  CONSTRAINT "annotations_datapoint_id_fkey" FOREIGN KEY ("datapoint_id")
    REFERENCES "public"."dataset_datapoints" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE,
  CONSTRAINT "annotations_annotation_task_id_fkey" FOREIGN KEY ("annotation_task_id")
    REFERENCES "public"."annotation_tasks" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE INDEX "annotations_datapoint_id_index"
  ON "public"."annotations" USING btree
  ("datapoint_id");

CREATE INDEX "annotations_user_id_index"
  ON "public"."annotations" USING btree
  ("user_id");

CREATE UNIQUE INDEX "annotations_annotation_task_id_datapoint_id_user_id_index"
  ON "public"."annotations" USING btree
  ("annotation_task_id", "datapoint_id", "user_id");

CREATE TABLE "public"."annotation_features"(
  "id" serial NOT NULL,
  "annotation_id" int NOT NULL,
  "feature_definition_id" int NOT NULL,
  "feature_type" text NOT NULL CONSTRAINT "feature_type" CHECK (char_length("feature_type") <= 60),
  "feature" json NOT NULL,

  PRIMARY KEY ("id"),
  CONSTRAINT "annotation_features_feature_definition_id_fkey" FOREIGN KEY ("feature_definition_id")
    REFERENCES "public"."dataset_feature_definitions" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE,
  CONSTRAINT "annotation_features_annotation_id_fkey" FOREIGN KEY ("annotation_id")
    REFERENCES "public"."annotations" ("id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE UNIQUE INDEX "annotation_features_annotation_id_feature_definition_id_index"
  ON "public"."annotation_features" USING btree
  ("annotation_id", "feature_definition_id");

CREATE INDEX "annotation_features_feature_definition_id_index"
  ON "public"."annotation_features" USING btree
  ("feature_definition_id");
