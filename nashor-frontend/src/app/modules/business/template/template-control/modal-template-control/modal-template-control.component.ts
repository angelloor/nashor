import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { LayoutService } from 'app/layout/layout.service';
import { ModalTemplateControlDetailsComponent } from './modal-template-control-details/modal-template-control-details.component';

@Component({
  selector: 'app-modal-template-control',
  templateUrl: './modal-template-control.component.html',
})
export class ModalTemplateControlComponent implements OnInit {
  constructor(
    private _activatedRoute: ActivatedRoute,
    private _matDialog: MatDialog,
    private _router: Router,
    private _layoutService: LayoutService
  ) {}

  ngOnInit(): void {
    // Launch the modal
    this._layoutService.setOpenModal(true);

    this._matDialog
      .open(ModalTemplateControlDetailsComponent, {
        minHeight: 'inherit',
        maxHeight: '90vh',
        height: 'auto',
        width: '32rem',
        maxWidth: '',
        panelClass: ['mat-dialog-cont'],
        data: {
          data: '',
        },
        disableClose: true,
      })
      .afterClosed()
      .subscribe(() => {
        // Go up twice because card routes are setup like this; "card/CARD_ID"
        this._router.navigate(['./../..'], {
          relativeTo: this._activatedRoute,
        });
      });
  }
}
