import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MessageAPI } from 'app/core/app/app.type';
import { NotificationService } from 'app/shared/notification/notification.service';
import { Subject, takeUntil } from 'rxjs';
import { flowVersionLevel } from '../flow-version/flow-version-level/flow-version-level.data';
import { FlowVersionLevelService } from '../flow-version/flow-version-level/flow-version-level.service';
import { FlowVersionLevel } from '../flow-version/flow-version-level/flow-version-level.types';
import { FlowVersion } from '../flow-version/flow-version.types';
import { ModalEditPositionLevelFatherService } from './modal-edit-position-level-father.service';

@Component({
  selector: 'app-modal-edit-position-level-father',
  templateUrl: './modal-edit-position-level-father.component.html',
})
export class ModalEditPositionLevelFatherComponent implements OnInit {
  id_user_: string = '';
  id_flow_version_level: string = '';
  flowVersionLevels: FlowVersionLevel[] = [];

  position_level_father: number = 0;

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  flowVersionLevelForm!: FormGroup;
  flowVersionLevel: FlowVersionLevel = flowVersionLevel;
  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _modalEditPositionLevelFatherService: ModalEditPositionLevelFatherService,
    private _flowVersionLevelService: FlowVersionLevelService,
    private _notificationService: NotificationService
  ) {}

  ngOnInit(): void {
    this.id_user_ = this._data.id_user_;
    this.id_flow_version_level = this._data.id_flow_version_level;
    this.flowVersionLevels = this._data.flowVersionLevels;
    /**
     * form
     */
    this.flowVersionLevelForm = this._formBuilder.group({
      position_level: [
        {
          value: '',
          disabled: true,
        },
        [Validators.required],
      ],
      position_level_father: ['', [Validators.required]],
    });

    this._flowVersionLevelService
      .specificReadInLocal(this.id_flow_version_level)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe();
    /**
     * Get the FlowVersion
     */
    this._flowVersionLevelService.flowVersionLevel$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_flowVersionLevel: FlowVersionLevel) => {
        this.flowVersionLevel = _flowVersionLevel;
        /**
         * Patch values to the form
         */
        this.patchForm();
      });
  }
  /**
   * Pacth the form with the information of the database
   */
  patchForm(): void {
    this.flowVersionLevelForm.patchValue({
      ...this.flowVersionLevel,
    });

    if (this.flowVersionLevel.position_level_father != 0) {
      this.flowVersionLevelForm.get('position_level_father')?.disable();
    }
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
   * closeModalEditPositionLevelFather
   */
  closeModalEditPositionLevelFather(): void {
    this._modalEditPositionLevelFatherService.closeModalEditPositionLevelFather();
  }
  /**
   * updatePositionLevelFather
   */
  updatePositionLevelFather(update: boolean) {
    let flowVersionLevel = this.flowVersionLevelForm.getRawValue();

    this.position_level_father = update
      ? parseInt(flowVersionLevel.position_level_father)
      : 0;

    flowVersionLevel = {
      id_user_: parseInt(this.id_user_),
      ...this.flowVersionLevel,
      id_flow_version_level: parseInt(
        this.flowVersionLevel.id_flow_version_level
      ),
      flow_version: {
        ...this.flowVersionLevel.flow_version,
        id_flow_version: parseInt(
          this.flowVersionLevel.flow_version.id_flow_version
        ),
      },
      level: {
        ...this.flowVersionLevel.level,
        id_level: parseInt(this.flowVersionLevel.level?.id_level),
      },
      position_level: parseInt(flowVersionLevel.position_level),
      position_level_father: this.position_level_father,
    };
    /**
     * updateFlowVersion
     */
    this._flowVersionLevelService
      .update(flowVersionLevel)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_flowVersion: FlowVersion) => {
          if (!_flowVersion) {
            this._notificationService.error(
              'Ocurrió un error actualizando el nivel'
            );
          }
          /**
           * closeModalEditPositionLevelFather
           */
          this._modalEditPositionLevelFatherService.closeModalEditPositionLevelFather();
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
}
