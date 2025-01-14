#standardSQL
# INP by device

WITH
base AS (
  SELECT
    device,
    p75_inp,
    p75_inp_origin
  FROM
    `chrome-ux-report.materialized.device_summary`
  WHERE
    device IN ('desktop', 'phone') AND
    date IN ('2024-06-01')
)

SELECT
  device,
  percentile,
  APPROX_QUANTILES(p75_inp, 1000 IGNORE NULLS)[OFFSET(percentile * 10)] AS p75_inp,
  APPROX_QUANTILES(p75_inp_origin, 1000 IGNORE NULLS)[OFFSET(percentile * 10)] AS p75_inp_origin
FROM
  base,
  UNNEST([10, 25, 50, 75, 90, 100]) AS percentile
GROUP BY
  device,
  percentile
ORDER BY
  device,
  percentile
