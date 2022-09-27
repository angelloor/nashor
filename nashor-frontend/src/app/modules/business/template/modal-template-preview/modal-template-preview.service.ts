import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { ModalTemplatePreviewComponent } from './modal-template-preview.component';

@Injectable({
  providedIn: 'root',
})
export class ModalTemplatePreviewService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}

  dialogRef: any;

  openModalTemplatePreview(id_template: string, editMode: boolean) {
    this._layoutService.setOpenModal(true);

    return (this.dialogRef = this._dialog.open(ModalTemplatePreviewComponent, {
      minHeight: 'inherit',
      maxHeight: '90vh',
      height: 'auto',
      width: '80rem',
      maxWidth: '',
      panelClass: ['mat-dialog-cont'],
      data: { id_template, editMode },
      disableClose: true,
    }));
  }

  closeModalTemplatePreview() {
    this.dialogRef.close();
  }
}
