import { FlowVersion } from '../flow/flow-version/flow-version.types';
import { Official } from '../official/official.types';

export interface Process {
  id_process: string;
  official: Official;
  flow_version: FlowVersion;
  number_process: string;
  date_process: string;
  generated_task: boolean;
  finalized_process: boolean;
  deleted_process: boolean;
}
