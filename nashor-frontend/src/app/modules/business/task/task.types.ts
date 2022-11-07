import { Level } from '../level/level.types';
import { Official } from '../official/official.types';
import { Process } from '../process/process.types';

export interface Task {
  id_task: string;
  process: Process;
  official: Official;
  level: Level;
  number_task: string;
  type_status_task: TYPE_STATUS_TASK;
  date_task: string;
  deleted_task: boolean;
}
/**
 * Type Enum TYPE_STATUS_TASK
 */
export type TYPE_STATUS_TASK =
  | 'created'
  | 'progress'
  | 'reassigned'
  | 'dispatched';

export interface TYPE_STATUS_TASK_ENUM {
  name_type: string;
  value_type: TYPE_STATUS_TASK;
}

export const _typeStatusTask: TYPE_STATUS_TASK_ENUM[] = [
  {
    name_type: 'Creado',
    value_type: 'created',
  },
  {
    name_type: 'En progeso',
    value_type: 'progress',
  },
  {
    name_type: 'Reasignado',
    value_type: 'reassigned',
  },
  {
    name_type: 'Enviado',
    value_type: 'dispatched',
  },
];

/**
 * Type Enum TYPE_STATUS_TASK
 */
