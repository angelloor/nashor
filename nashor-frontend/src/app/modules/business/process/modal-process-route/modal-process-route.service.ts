import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { ModalProcessRouteComponent } from './modal-process-route.component';

@Injectable({
  providedIn: 'root',
})
export class ModalProcessRouteService {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}

  dialogRef: any;

  openModalProcessRoute(id_process: string, id_company: string) {
    this._layoutService.setOpenModal(true);

    return (this.dialogRef = this._dialog.open(ModalProcessRouteComponent, {
      minHeight: 'inherit',
      maxHeight: '90vh',
      height: 'auto',
      width: '60rem',
      maxWidth: '',
      panelClass: ['mat-dialog-cont'],
      data: { id_process, id_company },
      disableClose: true,
    }));
  }

  closeModalProcessRoute() {
    this.dialogRef.close();
  }
}
