import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { ModalSelectSystemEventComponent } from './modal-select-system-event.component';

@Injectable({
  providedIn: 'root',
})
export class ModalSelectSystemEventService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}
  dialogRef: any;

  openModalSelectSystemEvent() {
    this._layoutService.setOpenModal(true);

    return (this.dialogRef = this._dialog.open(
      ModalSelectSystemEventComponent,
      {
        minHeight: 'inherit',
        maxHeight: 'inherit',
        height: 'auto',
        width: '32rem',
        maxWidth: '',
        panelClass: ['mat-dialog-cont'],
        data: {},
        disableClose: true,
      }
    ));
  }

  closeModalSelectSystemEvent() {
    this.dialogRef.close();
  }
}
