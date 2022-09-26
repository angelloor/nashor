import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { ModalTaskComponent } from './modal-task.component';

@Injectable({
  providedIn: 'root',
})
export class ModalTaskService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}

  dialogRef: any;

  openModalTask(id_task: string, sourceProcess: boolean) {
    this._layoutService.setOpenModal(true);

    return (this.dialogRef = this._dialog.open(ModalTaskComponent, {
      minHeight: 'inherit',
      maxHeight: '90vh',
      height: 'auto',
      width: '50rem',
      maxWidth: '',
      data: {
        id_task,
        sourceProcess,
      },
      panelClass: ['mat-dialog-cont'],
      disableClose: true,
    }));
  }

  closeModalTask() {
    this.dialogRef.close();
  }
}
