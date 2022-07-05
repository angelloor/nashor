import { Company } from 'app/modules/core/company/company.types';

export interface Control {
  id_control: string;
  company: Company;
  type_control: TYPE_CONTROL;
  title_control: string;
  form_name_control: string;
  initial_value_control: string;
  required_control: boolean;
  min_length_control: number;
  max_length_control: number;
  placeholder_control: string;
  spell_check_control: boolean;
  options_control: option[];
  in_use: boolean;
  deleted_control: boolean;
}

export interface option {
  name: string;
  value: string;
}

/**
 * Type Enum TYPE_CONTROL
 */
export type TYPE_CONTROL =
  | 'input'
  | 'textArea'
  | 'radioButton'
  | 'checkBox'
  | 'select'
  | 'date'
  | 'dateRange';

export interface TYPE_CONTROL_ENUM {
  name_type: string;
  value_type: TYPE_CONTROL;
}

export const _typeControl: TYPE_CONTROL_ENUM[] = [
  {
    name_type: 'Entrada de texto',
    value_type: 'input',
  },
  {
    name_type: 'Párrafo',
    value_type: 'textArea',
  },
  {
    name_type: 'Opción multiple',
    value_type: 'radioButton',
  },
  {
    name_type: 'Casillas de verificación',
    value_type: 'checkBox',
  },
  {
    name_type: 'Lista desplegable',
    value_type: 'select',
  },
  {
    name_type: 'Fecha',
    value_type: 'date',
  },
  {
    name_type: 'Rango de fechas',
    value_type: 'dateRange',
  },
];
/**
 * Type Enum TYPE_CONTROL
 */
