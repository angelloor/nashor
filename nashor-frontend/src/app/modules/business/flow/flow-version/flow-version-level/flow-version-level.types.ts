import { FlowVersion } from '../flow-version.types';
import { Level } from '../../../level/level.types';

export interface FlowVersionLevel {
  id_flow_version_level: string;
  flow_version: FlowVersion;
  level: Level;
  position_level: number;
  is_level: boolean;
  is_go: boolean;
  is_finish: boolean;
  is_conditional: boolean;
  type_conditional: TYPE_ACTION;
  expression: string;
}

/**
 * Type Enum TYPE_ACTION
 */
export type TYPE_ACTION = 'value_replace_1' | 'value_replace_2';

export interface TYPE_ACTION_ENUM {
  name_type: string;
  value_type: TYPE_ACTION;
}

export const _typeConditional: TYPE_ACTION_ENUM[] = [
  {
    name_type: 'name_replace',
    value_type: 'value_replace_1',
  },
  {
    name_type: 'name_replace',
    value_type: 'value_replace_2',
  },
];
/**
 * Type Enum TYPE_ACTION
 */
