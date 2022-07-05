import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { ModalSelectItemCategoryComponent } from './modal-select-item-category.component';

@Injectable({
  providedIn: 'root',
})
export class ModalSelectItemCategoryService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}
  dialogRef: any;

  openModalSelectItemCategory() {
    this._layoutService.setOpenModal(true);

    return (this.dialogRef = this._dialog.open(
      ModalSelectItemCategoryComponent,
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

  closeModalSelectItemCategory() {
    this.dialogRef.close();
  }
}
