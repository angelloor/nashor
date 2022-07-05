import { company } from 'app/modules/core/company/company.data';
import { Attached } from './attached.types';

export const attacheds: Attached[] = [];
export const attached: Attached = {
  id_attached: ' ',
  company: company,
  name_attached: ' ',
  description_attached: ' ',
  length_mb_attached: 1,
  required_attached: false,
  deleted_attached: false,
};
