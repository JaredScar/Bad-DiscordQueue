create table if not exists queueStats (
    id int auto_increment,
    discordId varchar(255),
    queueStartTime datetime,
    queueStopTime datetime,
    queueType varchar(255),
    primary key (id)
);

/* 
 * select
 *     discordId as 'Discord Id',
 *     queueType as 'Queue Type',
 *     avg(timestampdiff(
 *         second,
 *         queueStartTime,
 *         queueStopTime
 *     )) as 'Queue Time Average (s)',
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
 *     discordId,
 *     queueType;
 */
