import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { ModalTemplateComponent } from './modal-template.component';

@Injectable({
  providedIn: 'root',
})
export class ModalTemplateService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}

  openModalTemplate(id_template: any) {
    this._layoutService.setOpenModal(true);
    return this._dialog.open(ModalTemplateComponent, {
      minHeight: 'inherit',
      maxHeight: '90vh',
      height: 'auto',
      width: '32rem',
      maxWidth: '',
      panelClass: ['mat-dialog-cont'],
      data: {
        id_template,
      },
      disableClose: true,
    });
  }

  closeModalTemplate() {
    this._dialog.closeAll();
  }
}
