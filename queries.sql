
-- Consulta para obtener el top 10 de canciones más reproducidas el 17 de febrero de 2025.
SELECT rank,artist_names,track_name,peak_rank,previous_rank,days_on_chart,streams 
FROM `xxx.regional-global-daily-2025-02-17` ORDER BY RANK ASC LIMIT 10

-- Consulta para obtener el top 10 de Artistas con más reproducciones por semana del 07 al 13 de febrero de 2025.
SELECT artist_names, SUM(streams) AS total_streams
FROM `xxx.regional-global-weekly-2025-02-13`
GROUP BY artist_names
ORDER BY total_streams DESC
LIMIT 10;

-- Consulta para obtener el top 10 de Artistas y número de canciones, con más reproducciones por semana del 07 al 13 de febrero de 2025.
SELECT 
    artist_names, 
    COUNT(track_name) AS num_songs,
    SUM(streams) AS total_streams
FROM `xxx.regional-global-weekly-2025-02-13`
GROUP BY artist_names
ORDER BY total_streams DESC
LIMIT 10

-- Consulta para obtener el top 10 de Artistas y número de canciones, más reproducidas el 17 febrero de 2025.
SELECT 
    artist_names, 
    COUNT(track_name) AS num_songs,
    SUM(streams) AS total_streams
FROM `xxx.regional-global-daily-2025-02-17`
GROUP BY artist_names
ORDER BY total_streams DESC
LIMIT 10

-- Consulta para obtener el top 10 de Artistas y número de canciones, más virales el 17 febrero de 2025. (*)
SELECT 
    v.artist_names, 
    COUNT(v.track_name) AS num_songs,
    SUM(r.streams) AS total_streams
FROM `xxx.viral-global-daily-2025-02-17` v
LEFT JOIN `xxx.regional-global-daily-2025-02-17` r
ON v.track_name = r.track_name
GROUP BY v.artist_names
ORDER BY total_streams DESC
LIMIT 10;

-- Consulta para obtener el top 10 de Artistas y número de canciones, más virales el 17 febrero de 2025. (*) Comprobando si la anterior tenia errores por posibles duplicados.
WITH regional_streams AS (
    SELECT 
        track_name, 
        SUM(streams) AS total_track_streams
    FROM `xxx.regional-global-daily-2025-02-17`
    GROUP BY track_name
)

SELECT 
    v.artist_names, 
    COUNT(DISTINCT v.track_name) AS num_songs,
    COALESCE(SUM(r.total_track_streams), 0) AS total_streams
FROM `xxx.viral-global-daily-2025-02-17` v
LEFT JOIN regional_streams r
ON v.track_name = r.track_name
GROUP BY v.artist_names
ORDER BY total_streams DESC
LIMIT 10;

-- Consulta para obtener la relacion entre rank viral VS stream
SELECT 
    v.track_name, 
    v.artist_names, 
    v.rank AS viral_rank, 
    r.rank AS stream_rank
FROM `xxx.viral-global-daily-2025-02-17` v
JOIN `xxx.regional-global-daily-2025-02-17` r
ON v.uri = r.uri
WHERE v.rank <= 50 AND r.rank <= 50
ORDER BY viral_rank;

-- Consulta para obtener la relacion entre rank stream VS viral (si solo es visual)
SELECT 
    v.track_name, 
    v.artist_names, 
    v.rank AS viral_rank, 
    r.rank AS stream_rank
FROM `xxx.viral-global-daily-2025-02-17` v
JOIN `xxx.regional-global-daily-2025-02-17` r
ON v.uri = r.uri
WHERE v.rank <= 50 AND r.rank <= 50
ORDER BY stream_rank;

-- Consulta para obtener el promedio de streams según posición en el ranking
SELECT 
  CASE 
    WHEN rank <= 10 THEN 'Top 10'
    WHEN rank <= 50 THEN 'Top 50'
    ELSE 'Top 100'
  END AS rank_group,
  AVG(streams) AS avg_streams
FROM `xxx.regional-global-daily-2025-02-17`
WHERE rank <= 100  -- Filtramos solo las posiciones del Top 100
GROUP BY rank_group
ORDER BY avg_streams DESC;
