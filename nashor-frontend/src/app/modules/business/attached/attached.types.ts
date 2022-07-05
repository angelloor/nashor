import { Company } from 'app/modules/core/company/company.types';

export interface Attached {
  id_attached: string;
  company: Company;
  name_attached: string;
  description_attached: string;
  length_mb_attached: number;
  required_attached: boolean;
  deleted_attached: boolean;

  isSelected?: boolean;
}
