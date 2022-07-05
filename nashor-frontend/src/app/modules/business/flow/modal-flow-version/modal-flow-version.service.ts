import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ModalFlowVersionComponent } from './modal-flow-version.component';

@Injectable({
  providedIn: 'root',
})
export class ModalFlowVersionService {
  constructor(private _dialog: MatDialog) {}

  openModalFlowVersion(id_flow: string) {
    return this._dialog.open(ModalFlowVersionComponent, {
      minHeight: 'inherit',
      maxHeight: '90vh',
      height: 'auto',
      width: '50rem',
      maxWidth: '',
      panelClass: ['mat-dialog-cont'],
      data: {
        id_flow,
      },
    });
  }

  closeModalFlowVersion() {
    this._dialog.closeAll();
  }
}
