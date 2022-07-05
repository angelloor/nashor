import { Company } from 'app/modules/core/company/company.types';
import { User } from 'app/modules/core/user/user.types';
import { Area } from '../area/area.types';
import { Position } from '../position/position.types';

export interface Official {
  id_official: string;
  company: Company;
  user: User;
  area: Area;
  position: Position;
  deleted_official: boolean;
  isSelected?: boolean;
}
