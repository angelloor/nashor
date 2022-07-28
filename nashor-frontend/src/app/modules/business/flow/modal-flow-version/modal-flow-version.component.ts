import { angelAnimations } from '@angel/animations';
import { AngelAlertType } from '@angel/components/alert';
import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import {
  FormArray,
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { NotificationService } from 'app/shared/notification/notification.service';
import { cloneDeep } from 'lodash';
import moment from 'moment';
import { Observable, Subject, takeUntil } from 'rxjs';
import { ControlService } from '../../control/control.service';
import { Control } from '../../control/control.types';
import { LevelService } from '../../level/level.service';
import { Level } from '../../level/level.types';
import { FlowVersionLevelService } from '../flow-version/flow-version-level/flow-version-level.service';
import { FlowVersionLevel } from '../flow-version/flow-version-level/flow-version-level.types';
import { flowVersion } from '../flow-version/flow-version.data';
import { FlowVersionService } from '../flow-version/flow-version.service';
import { FlowVersion } from '../flow-version/flow-version.types';
import { ModalVersionService } from '../modal-version/modal-version.service';
import { ModalFlowVersionService } from './modal-flow-version.service';

@Component({
  selector: 'app-modal-flow-version',
  templateUrl: './modal-flow-version.component.html',
  animations: angelAnimations,
})
export class ModalFlowVersionComponent implements OnInit {
  private _unsubscribeAll: Subject<any> = new Subject<any>();
  private data!: AppInitialData;
  id_company: string = '';

  flowVersions$!: Observable<FlowVersion[]>;
  /**
   * Alert
   */
  alert: { type: AngelAlertType; message: string } = {
    type: 'error',
    message: '',
  };
  showAlert: boolean = false;
  /**
   * Alert
   */
  categoriesLevel: Level[] = [];

  id_flow: string = '';

  isSelectedAll: boolean = false;

  flowVersionForm!: FormGroup;
  flowVersions: FlowVersion[] = [];
  flowVersion: FlowVersion = flowVersion;

  flowVersionLevels: FlowVersionLevel[] = [];
  listControls: Control[] = [];

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _store: Store<{ global: AppInitialData }>,
    private _modalFlowVersionService: ModalFlowVersionService,
    private _changeDetectorRef: ChangeDetectorRef,
    private _notificationService: NotificationService,
    private _flowVersionService: FlowVersionService,
    private _angelConfirmationService: AngelConfirmationService,
    private _levelService: LevelService,
    private _formBuilder: FormBuilder,
    private _flowVersionLevelService: FlowVersionLevelService,
    private _modalVersionService: ModalVersionService,
    private _controlService: ControlService
  ) {}

  ngOnInit(): void {
    this.id_flow = this._data.id_flow;

    /**
     * Subscribe to user changes of state
     */
    this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
      this.data = state.global;
      this.id_company = this.data.user.company.id_company;
    });
    /**
     * Subscribe to user changes of state
     */
    this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
      this.data = state.global;
    });
    // Create the form
    this.flowVersionForm = this._formBuilder.group({
      id_flow: [{ value: '', disabled: true }, [Validators.required]],
      lotFlowVersion: this._formBuilder.array([]),
      lotFlowVersionLevel: this._formBuilder.array([]),
    });

    this._levelService
      .byCompanyQueryRead(this.id_company, '*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_level: Level[]) => {
        this.categoriesLevel = _level;
      });

    this.flowVersions$ = this._flowVersionService.flowVersions$;
    /**
     * Get the FlowVersions
     */
    this._flowVersionService
      .byFlowRead(this.id_flow)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe();

    this._flowVersionService.flowVersions$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_flowVersion: FlowVersion[]) => {
        this.flowVersions = _flowVersion;
        /**
         * Clear the flowVersion form arrays
         */
        (this.flowVersionForm.get('lotFlowVersion') as FormArray).clear();

        const flowVersionFormGroups: any = [];

        /**
         * Iterate through them
         */
        this.flowVersions.forEach((_flowVersion) => {
          /**
           * Create an flowVersion form group
           */
          flowVersionFormGroups.push(
            this._formBuilder.group({
              id_flow_version: [_flowVersion.id_flow_version],
              number_flow_version: [_flowVersion.number_flow_version],
              status_flow_version: [_flowVersion.status_flow_version],
              creation_date_flow_version: [
                _flowVersion.creation_date_flow_version,
              ],
              validation: [_flowVersion.validation],
            })
          );
        });
        /**
         * Add the flowVersion form groups to the flowVersion form array
         */
        flowVersionFormGroups.forEach((flowVersionFormGroup: any) => {
          (this.flowVersionForm.get('lotFlowVersion') as FormArray).push(
            flowVersionFormGroup
          );
        });
      });

    this._flowVersionService.flowVersion$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_flowVersion: FlowVersion) => {
        this.flowVersion = _flowVersion;
        /**
         * Clear the flowVersion form arrays
         */
        if (
          this.flowVersion.id_flow_version != ' ' &&
          this.flowVersion.id_flow_version != ''
        ) {
          this._flowVersionLevelService
            .byFlowVersionRead(this.flowVersion.id_flow_version)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe();

          this._flowVersionLevelService.flowVersionLevels$
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe((_flowVersionLevels: FlowVersionLevel[]) => {
              this.flowVersionLevels = _flowVersionLevels;

              if (
                this.flowVersionLevels.length == this.categoriesLevel.length
              ) {
                this.isSelectedAll = true;
              } else {
                this.isSelectedAll = false;
              }
              /**
               * Filter select
               */
              /**
               * Reset the selection
               * 1) add attribute isSelected
               * 2) [disabled]="entity.isSelected" in mat-option
               */
              this.categoriesLevel.map((item, index) => {
                item = {
                  ...item,
                  isSelected: false,
                };
                this.categoriesLevel[index] = item;
              });

              let filterLevel: Level[] = cloneDeep(this.categoriesLevel);
              /**
               * Selected Items
               */
              this.flowVersionLevels.map((itemOne) => {
                /**
                 * All Items
                 */
                filterLevel.map((itemTwo, index) => {
                  if (itemTwo.id_level == itemOne.level?.id_level) {
                    itemTwo = {
                      ...itemTwo,
                      isSelected: true,
                    };
                    filterLevel[index] = itemTwo;
                  }
                });
              });

              this.categoriesLevel = filterLevel;
              /**
               * Filter select
               */
              (
                this.flowVersionForm.get('lotFlowVersionLevel') as FormArray
              ).clear();

              const flowVersionLevelFormGroups: any = [];
              /**
               * Iterate through them
               */
              this.flowVersionLevels.forEach(
                (_flowVersionLevel, index: number) => {
                  /**
                   * Create an flowVersion form group
                   */
                  flowVersionLevelFormGroups.push(
                    this._formBuilder.group({
                      id_flow_version_level: [
                        _flowVersionLevel.id_flow_version_level,
                      ],
                      name_level: [
                        {
                          value: _flowVersionLevel.level?.name_level,
                          disabled:
                            this.flowVersionLevels.length != index + 1 ||
                            this.isSelectedAll,
                        },
                      ],
                      flow_version: [_flowVersionLevel.flow_version],
                      level: [_flowVersionLevel.level],
                      position_level: [_flowVersionLevel.position_level],
                      type_element: [_flowVersionLevel.type_element],
                    })
                  );
                }
              );
              /**
               * Add the flowVersion form groups to the flowVersion form array
               */
              flowVersionLevelFormGroups.forEach(
                (flowVersionLevelFormGroup: any) => {
                  (
                    this.flowVersionForm.get('lotFlowVersionLevel') as FormArray
                  ).push(flowVersionLevelFormGroup);
                }
              );
            });
        }
      });
  }

  get formArrayVersion(): FormArray {
    return this.flowVersionForm.get('lotFlowVersion') as FormArray;
  }

  get formArrayLevel(): FormArray {
    return this.flowVersionForm.get('lotFlowVersionLevel') as FormArray;
  }

  getFromControl(
    formArray: FormArray,
    index: number,
    control: string
  ): FormControl {
    return formArray.controls[index].get(control) as FormControl;
  }
  /**
   * closeModalFlowVersion
   */
  closeModalFlowVersion(): void {
    this._modalFlowVersionService.closeModalFlowVersion();
  }
  /**
   * openModalVersion
   * @param id_flow_version
   */
  openModalVersion(id_flow_version: string): void {
    const editMode: boolean = true;
    this._controlService
      .byCompanyQueryRead(this.id_company, '*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe(() => {
        this._controlService.controls$
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((_controls: Control[]) => {
            this.listControls = _controls;
          });
        this._modalVersionService.openModalVersion(
          id_flow_version,
          this.listControls,
          editMode
        );
      });
  }
  /**
   * createFlowVersion
   */
  createFlowVersion(): void {
    this._angelConfirmationService
      .open({
        title: 'Añadir version',
        message:
          '¿Estás seguro de que deseas añadir una nueva version? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          const id_user_ = this.data.user.id_user;
          const id_flow = this.id_flow;
          /**
           * createFlowVersion
           */
          this._flowVersionService
            .create(id_user_, id_flow)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (_flowVersion: FlowVersion) => {
                if (_flowVersion) {
                  this._notificationService.success(
                    'Version agregada correctamente'
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
      });
  }
  /**
   * updateStatusFlowVersion
   * @param index
   */
  updateStatusFlowVersion(index: number): void {
    const id_user_ = this.data.user.id_user;
    const versionElementFormArray = this.flowVersionForm.get(
      'lotFlowVersion'
    ) as FormArray;
    let flowVersion = versionElementFormArray.getRawValue()[index];

    flowVersion = {
      id_user_: parseInt(id_user_),
      ...flowVersion,
      flow: {
        id_flow: parseInt(this.id_flow),
      },
      id_flow_version: parseInt(flowVersion.id_flow_version),
      number_flow_version: parseInt(flowVersion.number_flow_version),
      status_flow_version: flowVersion.status_flow_version,
    };

    delete flowVersion.validation;
    /**
     * updateFlowVersion
     */
    this._flowVersionService
      .update(flowVersion)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_flowVersion: FlowVersion) => {
          if (_flowVersion) {
            this._notificationService.success(
              'Nivel actualizado correctamente'
            );
          } else {
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
          /**
           * Return the status of mat-slide-toggle
           */
          this.getFromControl(
            this.formArrayVersion,
            index,
            'status_flow_version'
          ).patchValue(false);

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
  /**
   * deleteFlowVersion
   * @param index
   */
  deleteFlowVersion(index: number): void {
    const id_user_ = this.data.user.id_user;
    const versionElementFormArray = this.flowVersionForm.get(
      'lotFlowVersion'
    ) as FormArray;
    let flowVersion = versionElementFormArray.getRawValue()[index];

    if (!flowVersion.status_flow_version) {
      this._angelConfirmationService
        .open({
          title: 'Eliminar Version',
          message:
            '¿Estás seguro de que deseas eliminar esta version? ¡Esta acción no se puede deshacer!',
        })
        .afterClosed()
        .pipe(takeUntil(this._unsubscribeAll))
        .subscribe((confirm: ActionAngelConfirmation) => {
          if (confirm === 'confirmed') {
            /**
             * deleteFlowVersion
             */
            this._flowVersionService
              .delete(id_user_, flowVersion.id_flow_version)
              .pipe(takeUntil(this._unsubscribeAll))
              .subscribe({
                next: (response: boolean) => {
                  if (response) {
                    this._notificationService.success(
                      'Version eliminada correctamente'
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
        });
    } else {
      this._notificationService.error(
        'No se puede eliminar una version activa!'
      );
    }
  }
  /**
   * Format the given ISO_8601 date as a relative date
   *
   * @param date
   */
  formatDateAsRelative(date: string): string {
    return moment(date, moment.ISO_8601).locale('es').fromNow();
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
