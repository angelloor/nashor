import { company } from 'app/modules/core/company/company.data';
import { Control } from './control.types';

export const controls: Control[] = [];
export const control: Control = {
  id_control: ' ',
  company: company,
  type_control: 'input',
  title_control: ' ',
  form_name_control: ' ',
  initial_value_control: ' ',
  required_control: false,
  min_length_control: 1,
  max_length_control: 1,
  placeholder_control: ' ',
  spell_check_control: false,
  options_control: [],
  in_use: false,
  deleted_control: false,
};
