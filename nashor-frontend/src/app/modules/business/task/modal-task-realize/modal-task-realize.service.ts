import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { Task } from '../task.types';
import { ModalTaskRealizeComponent } from './modal-task-realize.component';

@Injectable({
  providedIn: 'root',
})
export class ModalTaskRealizeService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}

  dialogRef: any;

  openModalTaskRealize(task: Task, id_template: string) {
    this._layoutService.setOpenModal(true);

    return (this.dialogRef = this._dialog.open(ModalTaskRealizeComponent, {
      minHeight: 'inherit',
      maxHeight: '90vh',
      height: 'auto',
      width: '80rem',
      maxWidth: '',
      panelClass: ['mat-dialog-cont'],
      data: {
        task,
        id_template,
      },
      disableClose: true,
    }));
  }

  closeModalTaskRealize() {
    this.dialogRef.close();
  }
}
