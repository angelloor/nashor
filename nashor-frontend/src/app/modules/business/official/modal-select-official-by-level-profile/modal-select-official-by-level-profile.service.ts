import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { ModalSelectOfficialByLevelProfileComponent } from './modal-select-official-by-level-profile.component';

@Injectable({
  providedIn: 'root',
})
export class ModalSelectOfficialByLevelProfileService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}
  dialogRef: any;

  openModalSelectOfficialByLevelProfile(id_level_profile: string) {
    this._layoutService.setOpenModal(true);

    return (this.dialogRef = this._dialog.open(
      ModalSelectOfficialByLevelProfileComponent,
      {
        minHeight: 'inherit',
        maxHeight: 'inherit',
        height: 'auto',
        width: '32rem',
        maxWidth: '',
        panelClass: ['mat-dialog-cont'],
        data: {
          id_level_profile,
        },
        disableClose: true,
      }
    ));
  }

  closeModalSelectOfficialByLevelProfile() {
    this.dialogRef.close();
  }
}
