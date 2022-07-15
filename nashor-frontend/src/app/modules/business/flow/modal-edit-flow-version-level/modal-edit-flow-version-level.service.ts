import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { FlowVersionLevel } from '../flow-version/flow-version-level/flow-version-level.types';
import { ModalEditFlowVersionLevelComponent } from './modal-edit-flow-version-level.component';

@Injectable({
  providedIn: 'root',
})
export class ModalEditFlowVersionLevelService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}
  dialogRef: any;

  openModalEditFlowVersionLevel(
    id_user_: string,
    id_company: string,
    id_flow_version_level: string,
    flowVersionLevels: FlowVersionLevel[]
  ) {
    this._layoutService.setOpenModal(true);

    return (this.dialogRef = this._dialog.open(
      ModalEditFlowVersionLevelComponent,
      {
        minHeight: 'inherit',
        maxHeight: '90%',
        height: 'auto',
        width: '32rem',
        maxWidth: '',
        panelClass: ['mat-dialog-cont'],
        data: {
          id_user_,
          id_company,
          id_flow_version_level,
          flowVersionLevels,
        },
        disableClose: true,
      }
    ));
  }

  closeModalEditFlowVersionLevel() {
    this.dialogRef.close();
  }
}
