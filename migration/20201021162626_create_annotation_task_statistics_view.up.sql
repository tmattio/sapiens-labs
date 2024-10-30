CREATE VIEW "annotation_task_statistics" (annotation_task_id, dataset_id, user_id, done, user_done, total, user_total, progress) AS
SELECT 
  annotation_tasks.id as annotation_task_id,
  annotation_tasks.dataset_id as dataset_id,
  t4.user_id as user_id,
  COALESCE(t1.num_done, 0) AS done,
  COALESCE(t2.num_done, 0) AS user_done,
  COALESCE(t3.num_total, 0) AS total,
  COALESCE(t4.num_total, 0) AS user_total,
  COALESCE(t1.num_done::decimal * 100 / t3.num_total, 0) as progress,
  COALESCE(t2.num_done::decimal * 100 / t4.num_total, 0) as user_progress
FROM annotation_tasks
LEFT OUTER JOIN (
  SELECT annotation_task_id, COUNT(annotation_task_id) as num_done
  FROM annotations
  WHERE annotated_at IS NOT NULL
  GROUP BY annotation_task_id
) t1 ON t1.annotation_task_id = annotation_tasks.id
LEFT OUTER JOIN (
  SELECT annotation_task_id, user_id, COUNT(user_id) as num_done
  FROM annotations
  WHERE annotated_at IS NOT NULL
  GROUP BY annotation_task_id, user_id
) t2 ON t2.annotation_task_id = annotation_tasks.id
LEFT OUTER JOIN (
  SELECT annotation_task_id, COUNT(annotation_task_id) as num_total
  FROM annotations
  GROUP BY annotation_task_id
) t3 ON t3.annotation_task_id = annotation_tasks.id
LEFT OUTER JOIN (
  SELECT annotation_task_id, user_id, COUNT(user_id) as num_total
  FROM annotations
  GROUP BY annotation_task_id, user_id
) t4 ON t4.annotation_task_id = annotation_tasks.id;
