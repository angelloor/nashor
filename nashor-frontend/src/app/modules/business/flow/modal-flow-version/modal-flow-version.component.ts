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
import { Subject, takeUntil } from 'rxjs';
import { LevelService } from '../../level/level.service';
import { Level } from '../../level/level.types';
import { FlowVersionLevelService } from '../flow-version/flow-version-level/flow-version-level.service';
import { FlowVersionLevel } from '../flow-version/flow-version-level/flow-version-level.types';
import { flowVersion } from '../flow-version/flow-version.data';
import { FlowVersionService } from '../flow-version/flow-version.service';
import { FlowVersion } from '../flow-version/flow-version.types';
import { ModalFlowVersionService } from './modal-flow-version.service';

@Component({
  selector: 'app-modal-flow-version',
  templateUrl: './modal-flow-version.component.html',
  animations: angelAnimations,
})
export class ModalFlowVersionComponent implements OnInit {
  private _unsubscribeAll: Subject<any> = new Subject<any>();
  private data!: AppInitialData;
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
  flowVersions!: FlowVersion[];
  flowVersion: FlowVersion = flowVersion;

  flowVersionLevels: FlowVersionLevel[] = [];

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
    private _flowVersionLevelService: FlowVersionLevelService
  ) {}

  ngOnInit(): void {
    this.id_flow = this._data.id_flow;
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
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_level: Level[]) => {
        console.log(_level);
        this.categoriesLevel = _level;
      });

    this._flowVersionService.flowVersions$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_flowVersion: FlowVersion[]) => {
        console.log(_flowVersion);
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
        console.log(_flowVersion);
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
                  if (itemTwo.id_level == itemOne.level.id_level) {
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
                          value: _flowVersionLevel.level.name_level,
                          disabled:
                            this.flowVersionLevels.length != index + 1 ||
                            this.isSelectedAll,
                        },
                      ],
                      flow_version: [_flowVersionLevel.flow_version],
                      level: [_flowVersionLevel.level],
                      position_level: [_flowVersionLevel.position_level],
                      is_level: [_flowVersionLevel.is_level],
                      is_go: [_flowVersionLevel.is_go],
                      is_finish: [_flowVersionLevel.is_finish],
                      is_conditional: [_flowVersionLevel.is_conditional],
                      type_conditional: [_flowVersionLevel.type_conditional],
                      expression: [_flowVersionLevel.expression],
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
                  /**
                   * expandLevels firs flowVersion
                   */
                  this.expandLevels(0);
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
   * expandLevels
   * @param index
   */
  expandLevels(index: number): void {
    const versionElementFormArray = this.flowVersionForm.get(
      'lotFlowVersion'
    ) as FormArray;
    let flowVersion = versionElementFormArray.getRawValue()[index];
    console.log(flowVersion);
    this._flowVersionService.$flowVersion = flowVersion;
  }
  /**
   * resetLevels
   * @param last
   * @param index
   */
  resetLevels(last: boolean, index: number): void {
    if (!(last && index == 0 && this.flowVersions.length == 0)) {
      const versionElementFormArray = this.flowVersionForm.get(
        'lotFlowVersion'
      ) as FormArray;
      let flowVersion = versionElementFormArray.getRawValue()[index];
      this._flowVersionService.$flowVersion = flowVersion;
    }
  }
  /**
   * Add an empty level field
   */
  addLevelField(): void {
    const id_user_ = this.data.user.id_user;
    const id_flow_version = this.flowVersion.id_flow_version;

    this._flowVersionLevelService
      .create(id_user_, id_flow_version)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_flowVersionLevel: FlowVersionLevel) => {
          if (_flowVersionLevel) {
            this._notificationService.success('Level agregado correctamente');
          } else {
            this._notificationService.error(
              'Ocurrió un error agregando el level'
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
  /**
   * updateLevelField
   * @param index
   */
  updateLevelField(index: number) {
    const nivelsFormArray = this.flowVersionForm.get(
      'lotFlowVersionLevel'
    ) as FormArray;
    const id_user_ = this.data.user.id_user;
    let flowVersionLevel = nivelsFormArray.getRawValue()[index];

    const levelSet: Level = this.categoriesLevel.find(
      (level) => level.name_level == flowVersionLevel.name_level
    )!;

    flowVersionLevel = {
      id_user_: parseInt(id_user_),
      ...flowVersionLevel,
      id_flow_version_level: parseInt(flowVersionLevel.id_flow_version_level),
      flow_version: {
        id_flow_version: parseInt(
          flowVersionLevel.flow_version.id_flow_version
        ),
      },
      level: {
        id_level: parseInt(levelSet.id_level),
      },
      position_level: parseInt(flowVersionLevel.position_level),
    };

    console.log(flowVersionLevel);

    /**
     * updateFlowVersionLevel
     */
    this._flowVersionLevelService
      .update(flowVersionLevel)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_flowVersionLevel: FlowVersionLevel) => {
          if (_flowVersionLevel) {
            this._notificationService.success(
              'Level actualizado correctamente'
            );
          } else {
            this._notificationService.error(
              'Ocurrió un error actualizando el level'
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
    /**
     * Mark for check
     */
    this._changeDetectorRef.markForCheck();
  }
  /**
   * resetFlowVersionLevel
   */
  resetFlowVersionLevel(): void {
    const id_user_ = this.data.user.id_user;
    const id_flow_version = this.flowVersion.id_flow_version;

    this._flowVersionLevelService
      .resetFlowVersionLevel(id_user_, id_flow_version)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (response: boolean) => {
          if (response) {
            this._notificationService.success('Niveles restablecidos');
          } else {
            this._notificationService.error(
              'Ocurrió un error al restablecer los niveles'
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
  /**
   * Track by function for ngFor loops
   * @param index
   * @param item
   */
  trackByFn(index: number, item: any): any {
    return item.id || index;
  }
}
