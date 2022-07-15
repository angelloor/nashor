import { Level } from 'app/modules/business/level/level.types';
import { FlowVersion } from '../flow-version.types';

export interface FlowVersionLevel {
  id_flow_version_level: string;
  flow_version: FlowVersion;
  level: Level;
  position_level: number;
  position_level_father?: number;
  type_element: TYPE_ELEMENT;
  id_control?: string;
  operator?: TYPE_OPERATOR;
  value_against?: string;
  option_true?: boolean;
  x?: string;
  y?: string;
}

/**
 * Type Enum TYPE_ELEMENT
 */
export type TYPE_ELEMENT = 'level' | 'conditional';

export interface TYPE_ELEMENT_ENUM {
  name_type: string;
  value_type: TYPE_ELEMENT;
}

export const _typeElements: TYPE_ELEMENT_ENUM[] = [
  {
    name_type: 'Nivel',
    value_type: 'level',
  },
  {
    name_type: 'Condicional',
    value_type: 'conditional',
  },
];
/**
 * Type Enum TYPE_ELEMENT
 */

/**
 * Type Enum TYPE_OPERATOR
 */
export type TYPE_OPERATOR = '==' | '!=' | '<' | '>' | '<=' | '>=';

export interface TYPE_OPERATOR_ENUM {
  name_type: string;
  value_type: TYPE_OPERATOR;
}

export const _typeOperators: TYPE_OPERATOR_ENUM[] = [
  {
    name_type: 'igual',
    value_type: '==',
  },
  {
    name_type: 'Diferente',
    value_type: '!=',
  },
  {
    name_type: 'Menor',
    value_type: '<',
  },
  {
    name_type: 'Mayor',
    value_type: '>',
  },
  {
    name_type: 'Menor que',
    value_type: '<=',
  },
  {
    name_type: 'Mayor que',
    value_type: '>=',
  },
];
/**
 * Type Enum TYPE_OPERATOR
 */
