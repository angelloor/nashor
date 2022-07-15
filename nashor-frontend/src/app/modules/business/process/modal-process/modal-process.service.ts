import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { ModalProcessComponent } from './modal-process.component';

@Injectable({
  providedIn: 'root',
})
export class ModalProcessService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}

  dialogRef: any;

  openModalProcess() {
    this._layoutService.setOpenModal(true);

    return (this.dialogRef = this._dialog.open(ModalProcessComponent, {
      minHeight: 'inherit',
      maxHeight: '90vh',
      height: 'auto',
      width: '50rem',
      maxWidth: '',
      panelClass: ['mat-dialog-cont'],
      disableClose: true,
    }));
  }

  closeModalProcess() {
    this.dialogRef.close();
  }
}
