create table if not exists queueStats (
    id int auto_increment,
    discordId varchar(255),
    queueStartTime datetime,
    queueStopTime datetime,
    primary key (id)
);

/* 
 * select
 *     discordId as 'Discord Id',
 *     avg(timestampdiff(
 *         second,
 *         queueStartTime,
 *         queueStopTime
 *     )) as 'QueueTime Average (s)',
 *     stddev(timestampdiff(
 *         second,
 *         queueStartTime,
 *         queueStopTime
 *     )) as 'Queue Time Std. Dev. (s)',
 *     count(1)
 * from queueStats
 * where
 *     queueStopTime is not null
 *     and queueStopTime <> '12/31/9999'
 * group by
 *     discordId;
 */
