import {
  ActionAngelConfirmation,
  AngelConfirmationService
} from '@angel/services/confirmation';
import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import { FormArray, FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { Subject, takeUntil } from 'rxjs';
import { Control } from '../../control/control.types';
import { ModalTemplatePreviewService } from '../../template/modal-template-preview/modal-template-preview.service';
import { FlowVersionLevelService } from '../flow-version/flow-version-level/flow-version-level.service';
import {
  FlowVersionLevel,
  TYPE_ELEMENT
} from '../flow-version/flow-version-level/flow-version-level.types';
import { flowVersion } from '../flow-version/flow-version.data';
import { FlowVersionService } from '../flow-version/flow-version.service';
import { FlowVersion } from '../flow-version/flow-version.types';
import { Flow } from '../flow.types';
import { ModalEditFlowVersionLevelService } from '../modal-edit-flow-version-level/modal-edit-flow-version-level.service';
import { ModalEditPositionLevelFatherService } from '../modal-edit-position-level-father/modal-edit-position-level-father.service';
import { ModalVersionService } from './modal-version.service';

@Component({
  selector: 'app-modal-version',
  templateUrl: './modal-version.component.html',
  styleUrls: ['./modal-version.component.scss'],
})
export class ModalVersionComponent implements OnInit {
  id_flow_version: string = '';
  id_company: string = '';

  editMode: boolean = false;

  private _unsubscribeAll: Subject<any> = new Subject<any>();
  private data!: AppInitialData;

  listFlow: Flow[] = [];
  versionForm!: FormGroup;

  index!: number;

  flowVersion: FlowVersion = flowVersion;

  flowVersionLevels: FlowVersionLevel[] = [];

  position_level: number = 0;
  type_element!: TYPE_ELEMENT;

  listControls: Control[] = [];

  constructor(
    private _store: Store<{ global: AppInitialData }>,
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _changeDetectorRef: ChangeDetectorRef,
    private _modalVersionService: ModalVersionService,
    private _flowVersionLevelService: FlowVersionLevelService,
    private _flowVersionService: FlowVersionService,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _modalEditPositionLevelFatherService: ModalEditPositionLevelFatherService,
    private _modalEditFlowVersionLevelService: ModalEditFlowVersionLevelService,
    private _modalTemplatePreviewService: ModalTemplatePreviewService
  ) {}

  ngOnInit(): void {
    this.id_flow_version = this._data.id_flow_version;
    this.listControls = this._data.listControls;
    this.editMode = this._data.editMode;
    /**
     * Subscribe to user changes of state
     */
    this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
      this.data = state.global;
      this.id_company = this.data.user.company.id_company;
    });
    /**
     * form
     */
    this.versionForm = this._formBuilder.group({
      lotFlowVersionLevel: this._formBuilder.array([]),
    });

    this._flowVersionService
      .specificRead(this.id_flow_version)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe();

    /**
     * Get the validations
     */
    this._flowVersionService.flowVersion$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_flowVersion: FlowVersion) => {
        this.flowVersion = _flowVersion;
        /**
         * byFlowVersionRead
         */
        if (this.flowVersion.id_flow_version != ' ') {
          this._flowVersionLevelService
            .byFlowVersionRead(this.flowVersion.id_flow_version)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe();
        }

        this._changeDetectorRef.markForCheck();
      });

    this._flowVersionLevelService.flowVersionLevels$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_flowVersionLevels: FlowVersionLevel[]) => {
        this.flowVersionLevels = _flowVersionLevels;

        (this.versionForm.get('lotFlowVersionLevel') as FormArray).clear();

        const flowVersionLevelFormGroups: any = [];
        /**
         * Iterate through them
         */
        this.flowVersionLevels.forEach((_flowVersionLevel, index: number) => {
          /**
           * Create an flowVersion form group
           */

          flowVersionLevelFormGroups.push(
            this._formBuilder.group({
              id_flow_version_level: [_flowVersionLevel.id_flow_version_level],
              name_level: [_flowVersionLevel.level?.name_level],
              flow_version: [_flowVersionLevel.flow_version],
              level: [_flowVersionLevel.level],
              position_level: [_flowVersionLevel.position_level],
              position_level_father: [_flowVersionLevel.position_level_father],
              type_element: [_flowVersionLevel.type_element],
              id_control: [
                this.getFormNameControl(_flowVersionLevel.id_control!),
              ],
              operator: [_flowVersionLevel.operator],
              value_against: [_flowVersionLevel.value_against],
              option_true: [_flowVersionLevel.option_true],
              x: [_flowVersionLevel.x],
              y: [_flowVersionLevel.y],
            })
          );
        });
        /**
         * Add the flowVersion form groups to the flowVersion form array
         */
        flowVersionLevelFormGroups.forEach((flowVersionLevelFormGroup: any) => {
          (this.versionForm.get('lotFlowVersionLevel') as FormArray).push(
            flowVersionLevelFormGroup
          );
        });
      });
  }
  /**
   * getFormNameControl
   * @param id_control
   * @returns
   */
  getFormNameControl(id_control: string): string {
    return id_control != '0'
      ? this.listControls.find(
          (control: Control) => control.id_control == id_control
        )?.form_name_control!
      : '';
  }
  /**
   * getIdControl
   * @param form_name_control
   * @returns
   */
  getIdControl(form_name_control: string): string {
    return this.listControls.find(
      (control: Control) => control.form_name_control == form_name_control
    )?.id_control!;
  }
  /**
   * setIndex
   * @param index
   */
  setIndex(index: number): void {
    if (this.editMode) {
      this.index = index;

      const flowVersionLevelFormArray = this.versionForm.get(
        'lotFlowVersionLevel'
      ) as FormArray;
      let flowVersionLevel: FlowVersionLevel =
        flowVersionLevelFormArray.getRawValue()[this.index];

      this.type_element = flowVersionLevel.type_element;
      this.position_level = flowVersionLevel.position_level;
    }
  }
  /**
   * formArrayFlowVersionLevel
   */
  get formArrayFlowVersionLevel(): FormArray {
    return this.versionForm.get('lotFlowVersionLevel') as FormArray;
  }
  /**
   * getFromControl
   * @param formArray
   * @param index
   * @param control
   * @returns
   */
  getFromControl(
    formArray: FormArray,
    index: number,
    control: string
  ): FormControl {
    return formArray.controls[index].get(control) as FormControl;
  }
  /**
   * getValueFlowVersionLevel
   * @param i
   * @returns
   */
  getValueFlowVersionLevel(i: number): any {
    return this.formArrayFlowVersionLevel.getRawValue()[i];
  }
  /**
   * On destroy
   */
  /**
   * When the component is destroyed, unsubscribe from all subscriptions.
   */
  ngOnDestroy(): void {
    /**
     * Unsubscribe from all subscriptions
     */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
  }
  /**
   * createFlowVersionLevel
   */
  createFlowVersionLevel(type_element: TYPE_ELEMENT): void {
    if (this.editMode) {
      this._angelConfirmationService
        .open({
          title: 'Añadir elemento',
          message:
            '¿Estás seguro de que deseas añadir una nuevo elemento? ¡Esta acción no se puede deshacer!',
        })
        .afterClosed()
        .pipe(takeUntil(this._unsubscribeAll))
        .subscribe((confirm: ActionAngelConfirmation) => {
          if (confirm === 'confirmed') {
            const id_user_ = this.data.user.id_user;
            /**
             * Create the flow_version_level
             */
            this._flowVersionLevelService
              .create(id_user_, this.flowVersion.id_flow_version, type_element)
              .pipe(takeUntil(this._unsubscribeAll))
              .subscribe({
                next: (_flowVersionLevel: FlowVersionLevel) => {
                  if (_flowVersionLevel) {
                    this._notificationService.success(
                      'Elemento agregado correctamente'
                    );
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
          this._layoutService.setOpenModal(false);
        });
    }
  }
  /**
   * dragEnded
   * @param event
   */
  dragEnded(event: any, index: number) {
    if (this.editMode) {
      const id_user_ = this.data.user.id_user;

      const flowVersionLevelFormArray = this.versionForm.get(
        'lotFlowVersionLevel'
      ) as FormArray;
      let flowVersionLevel: FlowVersionLevel | any =
        flowVersionLevelFormArray.getRawValue()[index];

      flowVersionLevel = {
        id_user_: parseInt(id_user_),
        ...flowVersionLevel,
        flow_version: {
          ...flowVersionLevel.flow_version,
          id_flow_version: parseInt(
            flowVersionLevel.flow_version.id_flow_version
          ),
        },
        level: {
          ...flowVersionLevel.level,
          id_level: parseInt(flowVersionLevel.level.id_level),
        },
        id_flow_version_level: parseInt(flowVersionLevel.id_flow_version_level),
        position_level: parseInt(flowVersionLevel.position_level),
        position_level_father: parseInt(flowVersionLevel.position_level_father),
        id_control: !(
          flowVersionLevel.id_control === null ||
          flowVersionLevel.id_control === ' ' ||
          flowVersionLevel.id_control === ''
        )
          ? this.getIdControl(flowVersionLevel.id_control)
          : '',
        x: parseInt(flowVersionLevel.x!) + event.distance.x,
        y: parseInt(flowVersionLevel.y!) + event.distance.y,
      };

      this.flowVersionLevels[index] = flowVersionLevel;
      this._flowVersionLevelService.$flowVersionLevels = this.flowVersionLevels;

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
             * Mark for check
             */
            this._changeDetectorRef.markForCheck();
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
  /**
   * Delete the flowVersionLevel
   */
  deleteFlowVersionLevel(): void {
    if (this.editMode) {
      this._angelConfirmationService
        .open({
          title: 'Eliminar elemento',
          message:
            '¿Estás seguro de que deseas eliminar este elemento? ¡Esta acción no se puede deshacer!',
        })
        .afterClosed()
        .pipe(takeUntil(this._unsubscribeAll))
        .subscribe((confirm: ActionAngelConfirmation) => {
          if (confirm === 'confirmed') {
            /**
             * Get the current flowVersionLevel's id
             */
            const id_user_ = this.data.user.id_user;

            const flowVersionLevelFormArray = this.versionForm.get(
              'lotFlowVersionLevel'
            ) as FormArray;
            let flowVersionLevel: FlowVersionLevel | any =
              flowVersionLevelFormArray.getRawValue()[this.index];

            /**
             * Delete
             */
            this._flowVersionLevelService
              .delete(id_user_, flowVersionLevel.id_flow_version_level)
              .pipe(takeUntil(this._unsubscribeAll))
              .subscribe({
                next: (response: boolean) => {
                  if (response) {
                    /**
                     * Return if the flowVersionLevel wasn't deleted...
                     */
                    this._notificationService.success(
                      'Elemento eliminado correctamente'
                    );
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
            /**
             * Mark for check
             */
            this._changeDetectorRef.markForCheck();
          }
          this._layoutService.setOpenModal(false);
        });
    }
  }
  /**
   * resetFlowVersionLevel
   */
  resetFlowVersionLevel(): void {
    if (this.editMode) {
      this._angelConfirmationService
        .open({
          title: 'Restablecer versión',
          message:
            '¿Estás seguro de que deseas restablecer está versión? ¡Esta acción no se puede deshacer!',
        })
        .afterClosed()
        .pipe(takeUntil(this._unsubscribeAll))
        .subscribe((confirm: ActionAngelConfirmation) => {
          if (confirm === 'confirmed') {
            const id_user_ = this.data.user.id_user;
            /**
             * Delete
             */
            this._flowVersionLevelService
              .resetFlowVersionLevel(id_user_, this.flowVersion.id_flow_version)
              .pipe(takeUntil(this._unsubscribeAll))
              .subscribe({
                next: (response: boolean) => {
                  if (response) {
                    this._notificationService.success(
                      'Versión restablecida correctamente'
                    );
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
            /**
             * Mark for check
             */
            this._changeDetectorRef.markForCheck();
          }
          this._layoutService.setOpenModal(false);
        });
    }
  }
  /**
   * closeModalVersion
   */
  closeModalVersion(): void {
    this._modalVersionService.closeModalVersion();
  }
  /**
   * openModalEditPositionLevelFather
   */
  openModalEditPositionLevelFather(): void {
    if (this.editMode) {
      const id_user_ = this.data.user.id_user;
      const flowVersionLevelFormArray = this.versionForm.get(
        'lotFlowVersionLevel'
      ) as FormArray;
      let flowVersionLevel: FlowVersionLevel | any =
        flowVersionLevelFormArray.getRawValue()[this.index];

      const flowVersionLevels: FlowVersionLevel[] = flowVersionLevelFormArray
        .getRawValue()
        .filter(
          (item: FlowVersionLevel) =>
            item.position_level != flowVersionLevel.position_level
        );

      this._modalEditPositionLevelFatherService.openModalEditPositionLevelFather(
        id_user_,
        flowVersionLevel.id_flow_version_level,
        flowVersionLevels
      );
    }
  }
  /**
   * openModalEditFlowVersionLevel
   */
  openModalEditFlowVersionLevel(): void {
    if (this.editMode) {
      const id_user_ = this.data.user.id_user;
      const id_company = this.data.user.company.id_company;
      const flowVersionLevelFormArray = this.versionForm.get(
        'lotFlowVersionLevel'
      ) as FormArray;
      let flowVersionLevel: FlowVersionLevel | any =
        flowVersionLevelFormArray.getRawValue()[this.index];

      this._modalEditFlowVersionLevelService.openModalEditFlowVersionLevel(
        id_user_,
        id_company,
        flowVersionLevel.id_flow_version_level,
        this.flowVersionLevels
      );
    }
  }
  /**
   * openModalTemplatePreview
   */
  openModalTemplatePreview(): void {
    if (this.editMode) {
      const editMode: boolean = true;

      const flowVersionLevelFormArray = this.versionForm.get(
        'lotFlowVersionLevel'
      ) as FormArray;
      let flowVersionLevel: FlowVersionLevel | any =
        flowVersionLevelFormArray.getRawValue()[this.index];

      const id_template = flowVersionLevel.level.template.id_template;

      this._modalTemplatePreviewService.openModalTemplatePreview(
        id_template,
        editMode
      );
    }
  }
  /**
   * Track by function for ngFor loops
   * @param index
   * @param item
   */
  trackByFn(index: number, item: any): any {
    return item.id || index;
  }
}
