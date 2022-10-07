import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { ModalDocumentationProfileAttachedsComponent } from './modal-documentation-profile-attacheds.component';

@Injectable({
  providedIn: 'root',
})
export class ModalDocumentationProfileAttachedsService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}
  _dialogRef: any;

  openModalDocumentationProfileAttacheds(id_documentation_profile: string) {
    this._layoutService.setOpenModal(true);
    return (this._dialogRef = this._dialog.open(
      ModalDocumentationProfileAttachedsComponent,
      {
        minHeight: 'inherit',
        maxHeight: 'inherit',
        height: 'auto',
        width: '55rem',
        maxWidth: '',
        panelClass: ['mat-dialog-cont'],
        disableClose: true,
        data: {
          id_documentation_profile,
        },
      }
    ));
  }

  closeModalDocumentationProfileAttacheds() {
    this._dialogRef.close();
  }
}
