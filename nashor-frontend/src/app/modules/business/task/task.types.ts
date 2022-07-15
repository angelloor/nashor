import { Level } from '../level/level.types';
import { Official } from '../official/official.types';
import { Process } from '../process/process.types';

export interface Task {
  id_task: string;
  process: Process;
  official: Official;
  level: Level;
  creation_date_task: string;
  type_status_task: TYPE_STATUS_TASK;
  type_action_task: TYPE_ACTION_TASK;
  action_date_task: string;
  deleted_task: boolean;
}

/**
 * Type Enum TYPE_STATUS_TASK
 */
export type TYPE_STATUS_TASK = 'progress' | 'finished';

export interface TYPE_STATUS_TASK_ENUM {
  name_type: string;
  value_type: TYPE_STATUS_TASK;
}

export const _typeStatusTask: TYPE_STATUS_TASK_ENUM[] = [
  {
    name_type: 'En progeso',
    value_type: 'progress',
  },
  {
    name_type: 'Finalizado',
    value_type: 'finished',
  },
];

/**
 * Type Enum TYPE_STATUS_TASK
 */

/**
 * Type Enum TYPE_ACTION_TASK
 */
export type TYPE_ACTION_TASK = 'dispatched' | 'reassigned';

export interface TYPE_ACTION_TASK_ENUM {
  name_type: string;
  value_type: TYPE_ACTION_TASK;
}

export const _typeActionTask: TYPE_ACTION_TASK_ENUM[] = [
  {
    name_type: 'Enviado',
    value_type: 'dispatched',
  },
  {
    name_type: 'Reasignado',
    value_type: 'reassigned',
  },
];

/**
 * Type Enum TYPE_ACTION_TASK
 */
