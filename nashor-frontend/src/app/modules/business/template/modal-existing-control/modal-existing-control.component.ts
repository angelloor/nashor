import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MessageAPI } from 'app/core/app/app.type';
import { NotificationService } from 'app/shared/notification/notification.service';
import { Subject, takeUntil } from 'rxjs';
import { ControlService } from '../../control/control.service';
import {
  Control,
  TYPE_CONTROL,
  TYPE_CONTROL_ENUM,
  _typeControl,
} from '../../control/control.types';
import { TemplateControlService } from '../template-control/template-control.service';
import { ModalExistingControlService } from './modal-existing-control.service';

@Component({
  selector: 'app-modal-existing-control',
  templateUrl: './modal-existing-control.component.html',
})
export class ModalExistingControlComponent implements OnInit {
  id_user: string = '';
  id_template: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  /**
   * Type Enum
   */
  typeControl: TYPE_CONTROL_ENUM[] = _typeControl;
  /**
   * Type Enum
   */

  categoriesControl: Control[] = [];
  existingControlForm!: FormGroup;

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _modalExistingControlService: ModalExistingControlService,
    private _formBuilder: FormBuilder,
    private _controlService: ControlService,
    private _templateControlService: TemplateControlService,
    private _notificationService: NotificationService
  ) {}

  ngOnInit(): void {
    this.id_user = this._data.id_user;
    this.id_template = this._data.id_template;
    /**
     * get controls
     */
    this._controlService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((controls: Control[]) => {
        this.categoriesControl = controls;
      });
    /**
     * form
     */
    this.existingControlForm = this._formBuilder.group({
      id_control: ['', [Validators.required]],
    });
  }
  /**
   * On destroy
   */
  ngOnDestroy(): void {
    /**
     * Unsubscribe from all subscriptions
     */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
  }
  /**
   * close
   */
  closeExistingControl(): void {
    this._modalExistingControlService.closeExistingControl();
  }
  /**
   * send
   */
  send(): void {
    const id_control = this.existingControlForm.getRawValue().id_control;

    this._templateControlService
      .create(this.id_user, this.id_template, id_control)
      .subscribe({
        next: (response) => {
          if (response) {
            this._notificationService.success('Control agregado correctamente');
            this.closeExistingControl();
          } else {
            this._notificationService.error(
              'Ocurrió un error agregando el control'
            );
          }
        },
        error: (error: { error: MessageAPI }) => {
          this._notificationService.error(
            !error.error
              ? '¡Error interno!, consulte al administrador.'
              : !error.error.description
              ? '¡Error interno!, consulte al administrador.'
              : error.error.description
          );
        },
      });
  }
  /**
   * getTypeSelect
   */
  getTypeSelect(type_navigation: TYPE_CONTROL): TYPE_CONTROL_ENUM {
    return this.typeControl.find(
      (control) => control.value_type == type_navigation
    )!;
  }
}
