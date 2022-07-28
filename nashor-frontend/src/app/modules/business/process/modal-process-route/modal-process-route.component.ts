import { OverlayRef } from '@angular/cdk/overlay';
import { Component, Inject, OnInit } from '@angular/core';
import { FormArray, FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Store } from '@ngrx/store';
import { AppInitialData } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { Subject, takeUntil } from 'rxjs';
import { FlowVersionLevelService } from '../../flow/flow-version/flow-version-level/flow-version-level.service';
import { FlowVersionLevel } from '../../flow/flow-version/flow-version-level/flow-version-level.types';
import { levelProfile } from '../../level-profile/level-profile.data';
import { LevelProfileService } from '../../level-profile/level-profile.service';
import { LevelProfile } from '../../level-profile/level-profile.types';
import { levelStatus } from '../../level-status/level-status.data';
import { LevelStatusService } from '../../level-status/level-status.service';
import { LevelStatus } from '../../level-status/level-status.types';
import { ProcessService } from '../process.service';
import { Process } from '../process.types';
import { ModalProcessRouteService } from './modal-process-route.service';

@Component({
  selector: 'app-modal-process-route',
  templateUrl: './modal-process-route.component.html',
  styleUrls: ['modal-process-route.component.scss'],
})
export class ModalProcessRouteComponent implements OnInit {
  id_process: string = '';
  process!: Process;

  id_company: string = '';

  listLevelProfile: LevelProfile[] = [];
  selectedLevelProfile: LevelProfile = levelProfile;

  listLevelStatus: LevelStatus[] = [];
  selectedLevelStatus: LevelStatus = levelStatus;

  processRouteForm!: FormGroup;

  private _tagsPanelOverlayRef!: OverlayRef;
  private _unsubscribeAll: Subject<any> = new Subject<any>();
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */
  flowVersionLevel: FlowVersionLevel[] = [];
  /**
   * Constructor
   */
  constructor(
    private _store: Store<{ global: AppInitialData }>,
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _layoutService: LayoutService,
    private _modalProcessRouteService: ModalProcessRouteService,
    private _processService: ProcessService,
    private _flowVersionLevelService: FlowVersionLevelService,
    private _levelProfileService: LevelProfileService,
    private _levelStatusService: LevelStatusService
  ) {}

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Lifecycle hooks
	  /** ----------------------------------------------------------------------------------------------------- */

  /**
   * On init
   */
  ngOnInit(): void {
    this.id_process = this._data.id_process;
    this.id_company = this._data.id_company;
    /**
     * isOpenModal
     */
    this._layoutService.isOpenModal$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_isOpenModal: boolean) => {
        this.isOpenModal = _isOpenModal;
      });
    /**
     * Create the process form
     */
    this.processRouteForm = this._formBuilder.group({
      id_process: [''],
      flow: [''],
      official: [''],
      flow_version: [''],
      number_process: [''],
      date_process: [''],
      generated_task: [''],
      finalized_process: [''],
      flowVersionLevels: this._formBuilder.array([]),
    });

    this._processService
      .specificReadInLocal(this.id_process)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe();

    this._processService.process$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_process: Process) => {
        this.process = _process;

        // LevelProfile
        this._levelProfileService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((level_profiles: LevelProfile[]) => {
            this.listLevelProfile = level_profiles;
          });

        // LevelStatus
        this._levelStatusService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((level_statuss: LevelStatus[]) => {
            this.listLevelStatus = level_statuss;
          });

        /**
         * Leer todas los niveles dentro del flujo
         */
        this._flowVersionLevelService
          .byFlowVersionExcludeConditionalRead(
            this.process.flow_version.id_flow_version
          )
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe();

        this._flowVersionLevelService.flowVersionLevels$
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((_flowVersionLevel: FlowVersionLevel[]) => {
            this.flowVersionLevel = _flowVersionLevel;

            /**
             * Clear the flowVersionLevels form arrays
             */
            (
              this.processRouteForm.get('flowVersionLevels') as FormArray
            ).clear();

            const lotFlowVersionLevelFormGroups: any = [];
            /**
             * Iterate through them
             */

            this.flowVersionLevel.forEach((_flowVersionLevel) => {
              /**
               * Create an elemento form group
               */

              this.selectedLevelProfile = this.getLevelProfile(
                _flowVersionLevel.level.level_profile.id_level_profile
              );

              this.selectedLevelStatus = this.getLevelStatus(
                _flowVersionLevel.level.level_status.id_level_status
              );

              lotFlowVersionLevelFormGroups.push(
                this._formBuilder.group({
                  id_flow_version_level:
                    _flowVersionLevel.id_flow_version_level,
                  flow_version: _flowVersionLevel.flow_version,
                  level: _flowVersionLevel.level,

                  level_profile: this.selectedLevelProfile,
                  level_status: this.selectedLevelStatus,

                  position_level: _flowVersionLevel.position_level,
                  position_level_father:
                    _flowVersionLevel.position_level_father,
                  type_element: _flowVersionLevel.type_element,
                  id_control: _flowVersionLevel.id_control,
                  operator: _flowVersionLevel.operator,
                  value_against: _flowVersionLevel.value_against,
                  option_true: _flowVersionLevel.option_true,
                  x: _flowVersionLevel.x,
                  y: _flowVersionLevel.y,
                  editMode: [
                    {
                      value: false,
                      disabled: false,
                    },
                  ],
                  isOwner: [true],

                  processItems: this._formBuilder.array([]),
                  processControls: this._formBuilder.array([]),
                  processAttacheds: this._formBuilder.array([]),
                })
              );
            });
            /**
             * Add the elemento form groups to the elemento form array
             */
            lotFlowVersionLevelFormGroups.forEach(
              (lotFlowVersionLevelFormGroup: any) => {
                (
                  this.processRouteForm.get('flowVersionLevels') as FormArray
                ).push(lotFlowVersionLevelFormGroup);
              }
            );
          });

        this.patchForm();
      });
  }
  /**
   * getLevelProfile
   * @param id_level_profile
   * @returns
   */
  getLevelProfile(id_level_profile: string): LevelProfile {
    return this.listLevelProfile.find(
      (item) => item.id_level_profile == id_level_profile
    )!;
  }
  /**
   * getLevelStatus
   * @param id_level_status
   * @returns
   */
  getLevelStatus(id_level_status: string): LevelStatus {
    return this.listLevelStatus.find(
      (item) => item.id_level_status == id_level_status
    )!;
  }

  get formArrayFlowVersionLevels(): FormArray {
    return this.processRouteForm.get('flowVersionLevels') as FormArray;
  }

  getFromControl(
    formArray: FormArray,
    index: number,
    control: string
  ): FormControl {
    return formArray.controls[index].get(control) as FormControl;
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.processRouteForm.patchValue(this.process);
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
    /**
     * Dispose the overlays if they are still on the DOM
     */
    if (this._tagsPanelOverlayRef) {
      this._tagsPanelOverlayRef.dispose();
    }
  }

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Public methods
	  /** ----------------------------------------------------------------------------------------------------- */
  /**
   * deployFlowVersionLevels
   * @param index
   */
  deployFlowVersionLevels(index: number): void {
    const elementFormArrayFlowVersionLevel = this.processRouteForm.get(
      'flowVersionLevels'
    ) as FormArray;

    let flowVersionLevel =
      elementFormArrayFlowVersionLevel.getRawValue()[index];
    this._flowVersionLevelService.$flowVersionLevel = flowVersionLevel;
  }

  /**
   * closeModalProcessRoute
   */
  closeModalProcessRoute(): void {
    this._modalProcessRouteService.closeModalProcessRoute();
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
