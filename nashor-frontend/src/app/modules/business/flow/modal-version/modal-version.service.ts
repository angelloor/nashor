import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { Control } from '../../control/control.types';
import { ModalVersionComponent } from './modal-version.component';

@Injectable({
  providedIn: 'root',
})
export class ModalVersionService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}
  dialogRef: any;

  openModalVersion(id_flow_version: string, listControls: Control[]) {
    this._layoutService.setOpenModal(true);

    return (this.dialogRef = this._dialog.open(ModalVersionComponent, {
      height: '95%',
      width: '95vw',
      maxWidth: '',
      panelClass: ['mat-dialog-cont'],
      data: {
        id_flow_version,
        listControls,
      },
      disableClose: true,
    }));
  }

  closeModalVersion() {
    this.dialogRef.close();
  }
}
