import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { FlowVersionLevel } from '../flow-version/flow-version-level/flow-version-level.types';
import { ModalEditPositionLevelFatherComponent } from './modal-edit-position-level-father.component';

@Injectable({
  providedIn: 'root',
})
export class ModalEditPositionLevelFatherService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}
  dialogRef: any;

  openModalEditPositionLevelFather(
    id_user_: string,
    id_flow_version_level: string,
    flowVersionLevels: FlowVersionLevel[]
  ) {
    this._layoutService.setOpenModal(true);

    return (this.dialogRef = this._dialog.open(
      ModalEditPositionLevelFatherComponent,
      {
        minHeight: 'inherit',
        maxHeight: 'inherit',
        height: 'auto',
        width: '32rem',
        maxWidth: '',
        panelClass: ['mat-dialog-cont'],
        data: {
          id_user_,
          id_flow_version_level,
          flowVersionLevels,
        },
        disableClose: true,
      }
    ));
  }

  closeModalEditPositionLevelFather() {
    this.dialogRef.close();
  }
}
