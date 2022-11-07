/*==============================================================*/
/* Type: TYPE_STATUS_TASK                                       */
/*==============================================================*/
CREATE TYPE business."TYPE_STATUS_TASK" AS ENUM
    ('progress', 'finished');

/*==============================================================*/
/* Type: TYPE_ACTION_TASK                                       */
/*==============================================================*/
CREATE TYPE business."TYPE_ACTION_TASK" AS ENUM
    ('received', 'reassigned', 'dispatched');