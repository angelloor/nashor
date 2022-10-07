import { angelAnimations } from '@angel/animations';
import { AngelAlertType } from '@angel/components/alert';
import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MessageAPI } from 'app/core/app/app.type';
import { NotificationService } from 'app/shared/notification/notification.service';
import { Subject, takeUntil } from 'rxjs';
import { ControlService } from '../../control/control.service';
import { Control } from '../../control/control.types';
import { level } from '../../level/level.data';
import { LevelService } from '../../level/level.service';
import { Level } from '../../level/level.types';
import { flowVersionLevel } from '../flow-version/flow-version-level/flow-version-level.data';
import { FlowVersionLevelService } from '../flow-version/flow-version-level/flow-version-level.service';
import {
  FlowVersionLevel,
  TYPE_ELEMENT,
  TYPE_ELEMENT_ENUM,
  TYPE_OPERATOR,
  TYPE_OPERATOR_ENUM,
  _typeElements,
  _typeOperators,
} from '../flow-version/flow-version-level/flow-version-level.types';
import { FlowVersion } from '../flow-version/flow-version.types';
import { ModalEditFlowVersionLevelService } from './modal-edit-flow-version-level.service';

@Component({
  selector: 'app-modal-edit-flow-version-level',
  templateUrl: './modal-edit-flow-version-level.component.html',
  animations: angelAnimations,
})
export class ModalEditFlowVersionLevelComponent implements OnInit {
  id_user_: string = '';
  id_company: string = '';
  id_flow_version_level: string = '';
  flowVersionLevels: FlowVersionLevel[] = [];

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  flowVersionLevelForm!: FormGroup;
  flowVersionLevel: FlowVersionLevel = flowVersionLevel;

  /**
   * Type Enum TYPE_ELEMENT
   */
  typeElements: TYPE_ELEMENT_ENUM[] = _typeElements;

  typeElementSelect!: TYPE_ELEMENT_ENUM;

  typeElement!: TYPE_ELEMENT;

  /**
   * Type Enum TYPE_ELEMENT
   */

  /**
   * Type Enum TYPE_OPERATOR
   */
  typeOperator: TYPE_OPERATOR_ENUM[] = _typeOperators;

  operatorSelect!: TYPE_OPERATOR_ENUM;

  /**
   * Type Enum TYPE_OPERATOR
   */

  editMode: boolean = false;
  /**
   * Alert
   */
  alert: { type: AngelAlertType; message: string } = {
    type: 'error',
    message: '',
  };
  showAlert: boolean = false;

  listFlowVersion: FlowVersion[] = [];
  listLevel: Level[] = [];

  selectedLevel: Level = level;

  listControls: Control[] = [];

  havedRelations: boolean = false;
  /**
   * Alert
   */
  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _modalEditFlowVersionLevelService: ModalEditFlowVersionLevelService,
    private _flowVersionLevelService: FlowVersionLevelService,
    private _notificationService: NotificationService,
    private _levelService: LevelService,
    private _controlService: ControlService
  ) {}

  ngOnInit(): void {
    this.id_user_ = this._data.id_user_;
    this.id_flow_version_level = this._data.id_flow_version_level;
    this.id_company = this._data.id_company;
    this.flowVersionLevels = this._data.flowVersionLevels;
    /**
     * form
     */
    this.flowVersionLevelForm = this._formBuilder.group({
      id_flow_version_level: [''],
      id_flow_version: [''],
      id_level: [''],
      position_level: ['', [Validators.required]],
      position_level_father: [''],
      type_element: [{ value: '', disabled: true }, [Validators.required]],
      id_control: [''],
      operator: [''],
      value_against: [''],
      option_true: [''],
      x: [''],
      y: [''],
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
        this.typeElement = this.flowVersionLevel.type_element;

        if (this.flowVersionLevel.position_level_father != 0) {
          this.havedRelations = true;
        }

        /**
         * Patch values to the form
         */
        this.patchForm();

        /**
         * Type Enum TYPE_ELEMENT
         */
        this.typeElementSelect = this.typeElements.find(
          (type_element) =>
            type_element.value_type == this.flowVersionLevel.type_element
        )!;
        /**
         * Type Enum TYPE_ELEMENT
         */

        /**
         * Type Enum TYPE_OPERATOR
         */
        this.operatorSelect = this.typeOperator.find(
          (rator) => rator.value_type == this.flowVersionLevel.operator
        )!;
        /**
         * Type Enum TYPE_OPERATOR
         */

        // Level
        this._levelService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((levels: Level[]) => {
            this.listLevel = levels;

            if (this.typeElement === 'conditional' && this.havedRelations) {
              const flowVersionLevelTop: FlowVersionLevel =
                this.flowVersionLevels.find(
                  (item: FlowVersionLevel) =>
                    item.position_level ==
                    this.flowVersionLevel.position_level_father
                )!;

              this.selectedLevel = this.listLevel.find(
                (item) => item.id_level == flowVersionLevelTop.level.id_level
              )!;

              this.flowVersionLevelForm.get('id_level')?.disable();
            } else {
              this.selectedLevel = this.listLevel.find(
                (item) => item.id_level == this.flowVersionLevel.level.id_level
              )!;
            }
          });

        this._controlService
          .byPositionLevel(this.id_user_, this.flowVersionLevel.position_level)
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe(() => {
            this._controlService.controls$
              .pipe(takeUntil(this._unsubscribeAll))
              .subscribe((_controls: Control[]) => {
                this.listControls = _controls;
              });
          });

        this.toggleEditMode(false);
      });
  }
  /**
   * Pacth the form with the information of the database
   */
  patchForm(): void {
    this.flowVersionLevelForm.patchValue({
      ...this.flowVersionLevel,
      id_flow_version: this.flowVersionLevel.flow_version.id_flow_version,
      id_level:
        this.typeElement === 'conditional' && this.havedRelations
          ? this.selectedLevel.id_level
          : this.flowVersionLevel.level.id_level,
      id_control: this.flowVersionLevel.id_control,
    });

    if (this.flowVersionLevel.position_level_father != 0) {
      this.flowVersionLevelForm.get('position_level_father')?.disable();
    }
  }
  /**
   * Toggle edit mode
   * @param editMode
   */
  toggleEditMode(editMode: boolean | null = null): void {
    this.patchForm();

    if (editMode === null) {
      this.editMode = !this.editMode;
      // Disable the form
      this.flowVersionLevelForm.enable();

      this.flowVersionLevelForm.get('type_element')?.disable();

      if (this.typeElement === 'conditional' && this.havedRelations) {
        this.flowVersionLevelForm.get('id_level')?.disable();
      }
    } else {
      this.flowVersionLevelForm.disable();
      this.editMode = editMode;
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
   * closeModalEditFlowVersionLevel
   */
  closeModalEditFlowVersionLevel(): void {
    this._modalEditFlowVersionLevelService.closeModalEditFlowVersionLevel();
  }
  /**
   * selectionChangeTypeElement
   */
  selectionChangeTypeElement(): void {
    const type_element: TYPE_ELEMENT =
      this.flowVersionLevelForm.getRawValue().type_element;
    this.typeElement = type_element;
  }
  /**
   * Update the flowVersionLevel
   */
  updateFlowVersionLevel(): void {
    /**
     * Get the flowVersionLevel
     */
    let flowVersionLevel = this.flowVersionLevelForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    flowVersionLevel = {
      ...flowVersionLevel,
      id_user_: parseInt(this.id_user_),
      id_flow_version_level: parseInt(flowVersionLevel.id_flow_version_level),
      flow_version: {
        id_flow_version: parseInt(flowVersionLevel.id_flow_version),
      },
      level: {
        id_level: parseInt(flowVersionLevel.id_level),
      },
      position_level: parseInt(flowVersionLevel.position_level),
      position_level_father: parseInt(flowVersionLevel.position_level_father),
    };
    /**
     * Update
     */
    this._flowVersionLevelService
      .update(flowVersionLevel)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_flowVersionLevel: FlowVersionLevel) => {
          if (_flowVersionLevel) {
            this._notificationService.success(
              'Elemento actualizada correctamente'
            );
            /**
             * Toggle the edit mode off
             */
            this.toggleEditMode(false);
            /**
             * Close modal
             */
            this.closeModalEditFlowVersionLevel();
          } else {
            this._notificationService.error(
              '¡Error interno!, consulte al administrador.'
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
   * getTypeElementEnum
   */
  getTypeElementEnum(element: TYPE_ELEMENT): TYPE_ELEMENT_ENUM {
    return this.typeElements.find(
      (type_element) => type_element.value_type == element
    )!;
  }
  /**
   * getTypeOperatorEnum
   */
  getTypeOperatorEnum(operator: TYPE_OPERATOR): TYPE_OPERATOR_ENUM {
    return this.typeOperator.find((rator) => rator.value_type == operator)!;
  }
}
