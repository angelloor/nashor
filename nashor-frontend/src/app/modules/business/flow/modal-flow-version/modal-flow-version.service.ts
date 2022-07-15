import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { ModalFlowVersionComponent } from './modal-flow-version.component';

@Injectable({
  providedIn: 'root',
})
export class ModalFlowVersionService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}
  dialogRef: any;

  openModalFlowVersion(id_flow: string) {
    this._layoutService.setOpenModal(true);

    return (this.dialogRef = this._dialog.open(ModalFlowVersionComponent, {
      minHeight: 'inherit',
      maxHeight: '90vh',
      height: 'auto',
      width: '90vw',
      maxWidth: '',
      panelClass: ['mat-dialog-cont'],
      data: {
        id_flow,
      },
    }));
  }

  closeModalFlowVersion() {
    this.dialogRef.close();
  }
}
