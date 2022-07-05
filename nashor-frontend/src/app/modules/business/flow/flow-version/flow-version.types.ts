import { Flow } from '../flow.types';

export interface FlowVersion {
  id_flow_version: string;
  flow: Flow;
  number_flow_version: number;
  status_flow_version: boolean;
  creation_date_flow_version: string;
  deleted_flow_version: boolean;
  validation?: boolean;
}
