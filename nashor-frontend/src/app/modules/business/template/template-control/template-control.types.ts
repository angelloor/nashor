import { Control } from '../../control/control.types';
import { Template } from '../template.types';

export interface TemplateControl {
  id_template_control: string;
  template: Template;
  control: Control;
  ordinal_position: number;
}
